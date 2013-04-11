package jfkbits;

import java.util.AbstractCollection;
import java.util.Arrays;
import java.util.Iterator;
import java.util.ArrayList;

import jfkbits.LispParser.Expr;

public class ExprList extends ArrayList<Expr> implements Expr
{
    ExprList parent = null;
    int indent =1;

    public int getIndent()
    {
        if (parent != null)
        {
            return parent.getIndent()+indent;
        }
        else return 0;
    }

    public void setIndent(int indent)
    {
        this.indent = indent;
    }



    public void setParent(ExprList parent)
    {
        this.parent = parent;
    }

    public String toString()
    {
        String indent = "";
        if (parent != null && parent.get(0) != this)
        {
            indent = "\n";
            char[] chars = new char[getIndent()];
            Arrays.fill(chars, ' ');
            indent += new String(chars);		
        }

        String output = indent+"(";
        for(Iterator<Expr> it=this.iterator(); it.hasNext(); )
        {
            Expr expr = it.next();
            output += expr.toString();
            if (it.hasNext())
                output += " ";
        }
        output += ")";
        return output;
    }

    @Override
    public synchronized boolean add(Expr e)
    {
        if (e instanceof ExprList)
        {
            ((ExprList) e).setParent(this);
            if (size() != 0 && get(0) instanceof Atom)
                ((ExprList) e).setIndent(2);
        }
        return super.add(e);
    }

}
