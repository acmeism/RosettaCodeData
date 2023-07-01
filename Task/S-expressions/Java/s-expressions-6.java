package jfkbits;


public class LispParser
{
    LispTokenizer tokenizer;

    public LispParser(LispTokenizer input)
    {
        tokenizer=input;
    }

    public class ParseException extends Exception
    {

    }

    public interface Expr
    {
        // abstract parent for Atom and ExprList
    }

    public Expr parseExpr() throws ParseException
    {
        Token token = tokenizer.next();
        switch(token.type)
        {
            case '(': return parseExprList(token);
            case '"': return new StringAtom(token.text);
            default: return new Atom(token.text);
        }
    }


    protected ExprList parseExprList(Token openParen) throws ParseException
    {
        ExprList acc = new ExprList();
        while(tokenizer.peekToken().type != ')')
        {
            Expr element = parseExpr();
            acc.add(element);
        }
        Token closeParen = tokenizer.next();
        return acc;
    }

}
