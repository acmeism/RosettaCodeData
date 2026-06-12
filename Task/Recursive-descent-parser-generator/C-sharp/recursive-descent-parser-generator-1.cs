using System.CodeDom.Compiler;
using System.Linq.Expressions;

public abstract record AST()
{
    public abstract string Emit(TextWriter w);
}

public record Leaf(string Text) : AST
{
    public override string ToString() =>
        $"\"{Text}\"";

    public override string Emit(TextWriter w) =>
        Text;
}

public record Node(char Op, AST[] Operands) : AST
{
    static int NodeID = 0;

    public override string ToString() =>
        $"{Op}({string.Join(", ", Operands.AsEnumerable())})";

    public override string Emit(TextWriter w)
    {
        var names = Operands.Select(o => o.Emit(w)).ToList();
        var id = ++NodeID;
        var name = $"_{id:0000}";

        switch (Operands.Length)
        {
            case 1:
                w.WriteLine($"{name} = {Op}{names[0]}");
                break;

            case 2:
                w.WriteLine($"{name} = {names[0]} {Op} {names[1]}");
                break;
        }

        return name;
    }
}

class ParserGenerator
{
    /*
        E --> T {( "+" | "-" ) T}
        T --> F {( "*" | "/" ) F}
        F --> P ["^" F]
        P --> v | "(" E ")" | "-" T"
    */

    readonly Dictionary<string, Expression<Func<Rule>>> grammar = new()
    {
        ["E"] = () => Seq(NonTerm("T"), While(Operator('+', '-'), Binary(NonTerm("T")))),
        ["T"] = () => Seq(NonTerm("F"), While(Operator('*', '/'), Binary(NonTerm("F")))),
        ["F"] = () => Seq(NonTerm("P"), If(Operator('^'), Binary(NonTerm("F")))),
        ["P"] = () => Options(
            Identifier(),
            Seq('(', NonTerm("E"), ')'),
            Seq(Operator('-'), Unary(NonTerm("T")))),
    };

    static void Main()
    {
        using var file = File.CreateText("RDParser.cs");
        using IndentedTextWriter w = new(file);
        ParserGenerator g = new();
        g.Generate("E", w);
    }

    static void Demo()
    {
        EParser p = new();
        var ast = p.Parse("(one + two) * three - four * five");
        Console.WriteLine("Abstract syntax tree:");
        Console.WriteLine(ast);
        Console.WriteLine();
        Console.WriteLine("Generated code:");
        ast.Emit(Console.Out);
    }

    void Generate(string name, IndentedTextWriter w)
    {
        var rule = grammar[name];
        w.WriteLine("using System.Text;");
        w.WriteLine();
        w.WriteLine($"public class {name}Parser");
        Block(w, () =>
        {
            w.WriteLine("static void Expect(IEnumerator<char> c, char ch)");

            Block(w, () =>
            {
                w.WriteLine("if (Consume(c) != ch)");
                w.WriteLine("    throw new Exception();");
            });
            w.WriteLine();
            w.WriteLine("static char Consume(IEnumerator<char> c)");

            Block(w, () =>
            {
                w.WriteLine("var result = c.Current;");
                w.WriteLine("_ = c.MoveNext();");
                w.WriteLine("return result;");
            });

            w.WriteLine();
            w.WriteLine("static Node MkNode(char op, params AST[] operands) =>");
            w.WriteLine("    new(op, operands);");
            w.WriteLine();
            w.WriteLine("static Leaf MkLeaf(string text) =>");
            w.WriteLine("    new(text);");
            w.WriteLine();
            w.WriteLine($"public AST Parse(string text)");

            Block(w, () =>
            {
                w.WriteLine("const char End = '\\u0003';");
                w.WriteLine("text = text.Replace(\" \", \"\") + End;");
                w.WriteLine("var c = text.GetEnumerator();");
                w.WriteLine("_ = c.MoveNext();");
                w.WriteLine($"AST t = {name}(c);");
                w.WriteLine("Expect(c, End);");
                w.WriteLine("return t;");
            });

            foreach (var (n, r) in grammar)
            {
                w.WriteLine();
                w.WriteLine($"AST {n}(IEnumerator<char> c)");

                Block(w, () =>
                {
                    NonTerminal(w, 't', r.Body);
                    w.WriteLine("return t;");
                });
            }
        });
    }

    void NonTerminal(IndentedTextWriter w, char varName, Expression e, int index = 0)
    {
        if (e is UnaryExpression cast)
        {
            if (index == 0)
                w.WriteLine("Consume(c);");
            else
                w.WriteLine($"Expect(c, '{cast.Operand}');");
            return;
        }

        var call = e as MethodCallExpression;
        var args = call!.Arguments!;

        switch (call!.Method.Name)
        {
            case nameof(NonTerm):
                w.WriteLine($"AST {varName} = {(args[0] as ConstantExpression)!.Value}(c);");
                break;

            case nameof(Seq):
                foreach (var arg in ((NewArrayExpression)args[0]).Expressions)
                {
                    NonTerminal(w, varName, arg, index++);
                }

                break;

            case nameof(While):
                w.WriteLine($"while ({Peek(args[0])})");
                ++varName;

                Block(w, () =>
                {
                    NonTerminal(w, varName, args[1]);
                });

                --varName;
                break;

            case nameof(If):
                w.WriteLine($"if ({Peek(args[0])})");
                ++varName;

                Block(w, () =>
                {
                    NonTerminal(w, varName, args[1]);
                });

                --varName;
                break;

            case nameof(Binary):
                w.WriteLine("var op = Consume(c);");
                var t = (char)(varName - 1);
                NonTerminal(w, varName, args[0]);
                w.WriteLine($"{t} = MkNode(op, {t}, {varName});");
                break;

            case nameof(Unary):
                w.WriteLine("var op = Consume(c);");
                NonTerminal(w, varName, args[0]);
                w.WriteLine($"{varName} = MkNode(op, {varName});");
                break;

            case nameof(Options):
                var el = "";
                w.WriteLine($"AST {varName};");
                t = varName;
                ++varName;
                foreach (var arg in ((NewArrayExpression)args[0]).Expressions)
                {
                    w.WriteLine($"{el}if ({Peek(arg)})");
                    Block(w, () =>
                    {
                        NonTerminal(w, varName, arg, index);
                        w.WriteLine($"{t} = {varName};");
                    });
                    el = "else ";
                }
                --varName;
                w.WriteLine("else");
                w.WriteLine("    throw new Exception();");
                break;

            case nameof(Operator):
                break;

            case nameof(Identifier):
                w.WriteLine($"StringBuilder {varName}_ = new();");
                w.WriteLine("while (char.IsLetter(c.Current))");

                Block(w, () =>
                {
                    w.WriteLine($"{varName}_.Append(Consume(c));");
                });

                w.WriteLine($"AST {varName} = MkLeaf({varName}_.ToString());");
                break;

            default:
                throw new NotImplementedException();
        }
    }

    string Peek(Expression e)
    {
        if (e is UnaryExpression cast)
        {
            return $"c.Current == '{cast.Operand}'";
        }

        var call = e as MethodCallExpression;
        var args = call!.Arguments;

        return call!.Method.Name switch
        {
            nameof(Seq) =>
                Peek(((NewArrayExpression)args[0]).Expressions[0]),

            nameof(Options) =>
                string.Join(" || ", ((NewArrayExpression)args[0]).Expressions.Select(arg => "(" + Peek(arg) + ")")),

            nameof(Operator) =>
                string.Join(" || ", ((NewArrayExpression)args[0]).Expressions.Select(arg => $"c.Current == '{arg}'")),

            nameof(Binary) or nameof(Unary) =>
                $"c.Current == '{args[0]}'",

            nameof(Identifier) =>
                "char.IsLetter(c.Current)",

            _ => throw new NotImplementedException(),
        };
    }

    static void Block(IndentedTextWriter w, Action action)
    {
        w.WriteLine("{");
        w.Indent++;
        action();
        w.Indent--;
        w.WriteLine("}");
    }

    static Rule NonTerm(string name) => new();
    static Rule Operator(params char[] ops) => new();
    static Rule Seq(params Rule[] rules) => new();
    static Rule Options(params Rule[] rules) => new();
    static Rule If(Rule cond, Rule r) => new();
    static Rule While(Rule cond, Rule r) => new();
    static Rule Identifier() => new();
    static Rule Binary(Rule r) => new();
    static Rule Unary(Rule r) => new();
}

record Rule()
{
    public static implicit operator Rule(char ch) => new();
}
