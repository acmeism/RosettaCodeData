using System.Text;

public class EParser
{
    static void Expect(IEnumerator<char> c, char ch)
    {
        if (Consume(c) != ch)
            throw new Exception();
    }

    static char Consume(IEnumerator<char> c)
    {
        var result = c.Current;
        _ = c.MoveNext();
        return result;
    }

    static Node MkNode(char op, params AST[] operands) =>
        new(op, operands);

    static Leaf MkLeaf(string text) =>
        new(text);

    public AST Parse(string text)
    {
        const char End = '\u0003';
        text = text.Replace(" ", "") + End;
        var c = text.GetEnumerator();
        _ = c.MoveNext();
        AST t = E(c);
        Expect(c, End);
        return t;
    }

    AST E(IEnumerator<char> c)
    {
        AST t = T(c);
        while (c.Current == '+' || c.Current == '-')
        {
            var op = Consume(c);
            AST u = T(c);
            t = MkNode(op, t, u);
        }
        return t;
    }

    AST T(IEnumerator<char> c)
    {
        AST t = F(c);
        while (c.Current == '*' || c.Current == '/')
        {
            var op = Consume(c);
            AST u = F(c);
            t = MkNode(op, t, u);
        }
        return t;
    }

    AST F(IEnumerator<char> c)
    {
        AST t = P(c);
        if (c.Current == '^')
        {
            var op = Consume(c);
            AST u = F(c);
            t = MkNode(op, t, u);
        }
        return t;
    }

    AST P(IEnumerator<char> c)
    {
        AST t;
        if (char.IsLetter(c.Current))
        {
            StringBuilder u_ = new();
            while (char.IsLetter(c.Current))
            {
                u_.Append(Consume(c));
            }
            AST u = MkLeaf(u_.ToString());
            t = u;
        }
        else if (c.Current == '(')
        {
            Consume(c);
            AST u = E(c);
            Expect(c, ')');
            t = u;
        }
        else if (c.Current == '-')
        {
            var op = Consume(c);
            AST u = T(c);
            u = MkNode(op, u);
            t = u;
        }
        else
            throw new Exception();
        return t;
    }
}
