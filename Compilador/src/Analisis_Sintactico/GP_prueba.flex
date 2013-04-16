package Analisis_Sintactico;

import java_cup.runtime.*;
%%

%class Scanner
%unicode
%cup
%line
%column
%function next_token

%{
  StringBuffer string = new StringBuffer();

  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} 

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}

Identifier = [a-zA-Z\_][^\$][a-zA-Z_0-9]* | "\$"+[a-zA-Z_0-9][a-zA-Z_0-9]*

//[:jletter:] [:jletterdigit:]*  

DecIntegerLiteral = 0 | [1-9][0-9]*

CharConst = \'+[:jletter:]+\' 

SChar = [^\"\\\n\r] | {EscChar}
EscChar = \\[ntbrf\\\'\"]

Decimales = {DecIntegerLiteral}+\.[0-9]*

%state STRING

%%

/* Palabras reservadas */

<YYINITIAL> "int"          { return symbol(sym.TInt,yytext()); }
<YYINITIAL> "String"            { return symbol(sym.TString,yytext()); }
<YYINITIAL> "boolean"           { return symbol(sym.TBoolean,yytext()); }
<YYINITIAL> "float"             { return symbol(sym.TFloat,yytext()); }
<YYINITIAL> "char"              { return symbol(sym.TChar,yytext()); }
<YYINITIAL> "true"              { return symbol(sym.TTrue,yytext()); }
<YYINITIAL> "false"             { return symbol(sym.TFalse,yytext()); }

<YYINITIAL> "public"          { return symbol(sym.TPublic,yytext()); }
<YYINITIAL> "class"          { return symbol(sym.TClass,yytext()); }
<YYINITIAL> "void"              { return symbol(sym.TVoid,yytext()); }
<YYINITIAL> "main"          { return symbol(sym.TMain,yytext()); }
<YYINITIAL> "static"     { return symbol(sym.TStatic,yytext()); }
<YYINITIAL> "extends"           { return symbol(sym.TExtends,yytext()); }
<YYINITIAL> "return"     { return symbol(sym.TReturn,yytext()); }

<YYINITIAL> "while"          { return symbol(sym.TWhile,yytext()); }
<YYINITIAL> "System"            { return symbol(sym.TSystem,yytext()); }
<YYINITIAL> "out"          { return symbol(sym.TOut,yytext()); }
<YYINITIAL> "println"           { return symbol(sym.TPrintln,yytext()); }
<YYINITIAL> "length"     { return symbol(sym.TLength,yytext()); }
<YYINITIAL> "this"              { return symbol(sym.TThis,yytext()); }
<YYINITIAL> "new"          { return symbol(sym.TNew,yytext()); }
<YYINITIAL> "if"                { return symbol(sym.TIf,yytext()); }
<YYINITIAL> "else"              { return symbol(sym.TElse,yytext()); }
<YYINITIAL> "!"                 { return symbol(sym.TNegacion,yytext()); }

<YYINITIAL> "import"            { return symbol(sym.TImport,yytext()); }
<YYINITIAL> "implements"        { return symbol(sym.TImplements,yytext()); }
<YYINITIAL> "exit"                 { return symbol(sym.TExit,yytext()); }
<YYINITIAL> "in"                 { return symbol(sym.TIn,yytext()); }
<YYINITIAL> "read"                 { return symbol(sym.TRead,yytext()); }




<YYINITIAL> {
  /* identificadores */ 
  {Identifier}                   { return symbol(sym.TID,yytext()); }
 
  /* literales enteros positivos */
  {DecIntegerLiteral}            { return symbol(sym.TIntegerLiteral); }
 /* \"                 { string.setLength(0); yybegin(TStringLiteral); } */

  {CharConst}                    { return symbol(sym.TStringConst,yytext()); }

  {Decimales}                    { return symbol(sym.TDecimales,yytext()); }

  /* operadores */
  "="                            { return symbol(sym.TAsig,yytext()); }
  "*"                            { return symbol(sym.TMult,yytext()); }
  "+"                            { return symbol(sym.TSuma,yytext()); }
  "-"                            { return symbol(sym.TResta,yytext()); }
  "/"                            { return symbol(sym.TDivision,yytext()); }

  "<"                            { return symbol(sym.TMenor,yytext()); }
  "<="                           { return symbol(sym.TMenorIgual,yytext()); }
  ">"                            { return symbol(sym.TMayor,yytext()); }
  ">="                           { return symbol(sym.TMayorIgual,yytext()); }
  "=="                           { return symbol(sym.TIgual,yytext()); }
  "!="                           { return symbol(sym.TDiferente,yytext()); }
  "||"                           { return symbol(sym.TO,yytext()); }
  "&&"                           { return symbol(sym.TY,yytext()); }
  

  /* otros simbolos v�lidos */
  "("                            { return symbol(sym.TParIzq,yytext()); }
  ")"                            { return symbol(sym.TParDer,yytext()); }
  "{"                            { return symbol(sym.TLlaveIzq,yytext()); }
  "}"                            { return symbol(sym.TLlaveDer,yytext()); }
  "["                            { return symbol(sym.TCorIzq,yytext()); }
  "]"                            { return symbol(sym.TCorDer,yytext()); }

  ";"                            { return symbol(sym.TPyComa,yytext()); }
  ","                            { return symbol(sym.TComa,yytext()); }
  "."                            { return symbol(sym.TPunto,yytext()); }
  ".*"                            { return symbol(sym.TPuntoAst,yytext()); }

  \"{SChar}*\"      { return symbol(sym.TStringLiteral,yytext());}
  
  /* commentarios */
  {Comment}                      { /* ignore */ }
 
  /* espacios en blanco */
  {WhiteSpace}                   { /* ignore */ }
}

<STRING> {
  \"                             { yybegin(YYINITIAL); 
                                   return symbol(sym.TStringLiteral, string.toString()); }
  [^\n\r\"\\]+                   { string.append( yytext() ); }
  \\t                            { string.append('\t'); }
  \\n                            { string.append('\n'); }

  \\r                            { string.append('\r'); }
  \\\"                           { string.append('\"'); }
  \\                             { string.append('\\'); }
}

/* caracteres no v�lidos */
.|\n                             { throw new RuntimeException("Error caracter inv�lido: <" + yytext() + "> en fila: " + yyline + " columna: " + yycolumn );
       /*throw new Error("Caracter no permitido <"+
                                                    yytext()+">");*/ }

