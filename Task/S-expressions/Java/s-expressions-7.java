import jfkbits.ExprList;
import jfkbits.LispParser;
import jfkbits.LispParser.ParseException;
import jfkbits.LispTokenizer;

public class LispParserDemo
{
    public static void main(String args[])
    {

        LispTokenizer tzr = new LispTokenizer(
            "((data \"quoted data\" 123 4.5)\n (data (!@# (4.5) \"(more\" \"data)\")))");
        LispParser parser = new LispParser(tzr);

        try
        {
            Expr result = parser.parseExpr();
            System.out.println(result);
        }
        catch (ParseException e1)
        {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
    }	
}
