/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Analisis_Sintactico;
import java.io.FileReader;
import java.io.StringReader;
import java_cup.runtime.Symbol;
/**
 *
 * @author Nookie
 */
public class Driver {
    private Scanner Scan;
    private Symbol TokenActual;
    private parser parse;
    
    public Driver(String path)
    {
       
        try
        {
            FileReader sr = new FileReader(path);
            Scan = new Scanner(sr);      
            parse = new parser(Scan);
            parse.parse();
       
        /*TokenActual = Scan.next_token();
        while(TokenActual.sym != sym.EOF)
        {
            System.out.println(TokenActual.value);
            TokenActual = Scan.next_token();            
        }*/
        }
        catch(Exception e)
        {
           throw new RuntimeException(e.getMessage());
        }
    }
}
