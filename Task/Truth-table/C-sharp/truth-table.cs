using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class TruthTable
{
    enum TokenType { Unknown, WhiteSpace, Constant, Operand, Operator, LeftParenthesis, RightParenthesis }

    readonly char trueConstant, falseConstant;
    readonly IDictionary<char, Operator> operators = new Dictionary<char, Operator>();

    public TruthTable(char falseConstant, char trueConstant)
    {
        this.trueConstant = trueConstant;
        this.falseConstant = falseConstant;
        Operators = new OperatorCollection(operators);
    }

    public OperatorCollection Operators { get; }

    public void PrintTruthTable(string expression, bool isPostfix = false)
    {
        try {
            foreach (string line in GetTruthTable(expression, isPostfix)) {
                Console.WriteLine(line);
            }
        } catch (ArgumentException ex) {
            Console.WriteLine(expression + "   " + ex.Message);
        }
    }

    public IEnumerable<string> GetTruthTable(string expression, bool isPostfix = false)
    {
        if (string.IsNullOrWhiteSpace(expression)) throw new ArgumentException("Invalid expression.");
        //Maps parameters to an index in BitSet
        //Makes sure they appear in the truth table in the order they first appear in the expression
        var parameters = expression
            .Where(c => TypeOf(c) == TokenType.Operand)
            .Distinct()
            .Reverse()
            .Select((c, i) => (symbol: c, index: i))
            .ToDictionary(p => p.symbol, p => p.index);

        int count = parameters.Count;
        if (count > 32) throw new ArgumentException("Cannot have more than 32 parameters.");
        string header = count == 0 ? expression : string.Join(" ",
            parameters.OrderByDescending(p => p.Value).Select(p => p.Key)) + " " + expression;

        if (!isPostfix) expression = ConvertToPostfix(expression);

        var values = default(BitSet);
        var stack = new Stack<char>(expression.Length);
        for (int loop = 1 << count; loop > 0; loop--) {
            foreach (char token in expression) stack.Push(token);
            bool result = Evaluate(stack, values, parameters);
            if (header != null) {
                if (stack.Count > 0) throw new ArgumentException("Invalid expression.");
                yield return header;
                header = null;
            }
            string line = (count == 0 ? "" : " ") + (result ? trueConstant : falseConstant);
            line = string.Join(" ", Enumerable.Range(0, count)
                .Select(i => values[count - i - 1] ? trueConstant : falseConstant)) + line;
            yield return line;
            values++;
        }
    }

    public string ConvertToPostfix(string infix)
    {
        var stack = new Stack<char>();
        var postfix = new StringBuilder();
        foreach (char c in infix) {
            switch (TypeOf(c)) {
            case TokenType.WhiteSpace:
                continue;
            case TokenType.Constant:
            case TokenType.Operand:
                postfix.Append(c);
                break;
            case TokenType.Operator:
                int precedence = Precedence(c);
                while (stack.Count > 0 && Precedence(stack.Peek()) > precedence) {
                    postfix.Append(stack.Pop());
                }
                stack.Push(c);
                break;
            case TokenType.LeftParenthesis:
                stack.Push(c);
                break;
            case TokenType.RightParenthesis:
                char top = default(char);
                while (stack.Count > 0) {
                    top = stack.Pop();
                    if (top == '(') break;
                    else postfix.Append(top);
                }
                if (top != '(') throw new ArgumentException("No matching left parenthesis.");
                break;
            default:
                throw new ArgumentException("Invalid character: " + c);
            }
        }
        while (stack.Count > 0) {
            char top = stack.Pop();
            if (top == '(') throw new ArgumentException("No matching right parenthesis.");
            postfix.Append(top);
        }
        return postfix.ToString();
    }

    private bool Evaluate(Stack<char> expression, BitSet values, IDictionary<char, int> parameters)
    {
        if (expression.Count == 0) throw new ArgumentException("Invalid expression.");
        char c = expression.Pop();
        TokenType type = TypeOf(c);
        while (type == TokenType.WhiteSpace) type = TypeOf(c = expression.Pop());
        switch (type) {
        case TokenType.Constant:
            return c == trueConstant;
        case TokenType.Operand:
            return values[parameters[c]];
        case TokenType.Operator:
            bool right = Evaluate(expression, values, parameters);
            Operator op = operators[c];
            if (op.Arity == 1) return op.Function(right, right);
            bool left = Evaluate(expression, values, parameters);
            return op.Function(left, right);
        default:
            throw new ArgumentException("Invalid character: " + c);
        }
    }

    private TokenType TypeOf(char c)
    {
        if (char.IsWhiteSpace(c)) return TokenType.WhiteSpace;
        if (c == '(') return TokenType.LeftParenthesis;
        if (c == ')') return TokenType.RightParenthesis;
        if (c == trueConstant || c == falseConstant) return TokenType.Constant;
        if (operators.ContainsKey(c)) return TokenType.Operator;
        if (char.IsLetter(c)) return TokenType.Operand;
        return TokenType.Unknown;
    }

    private int Precedence(char op) => operators.TryGetValue(op, out var o) ? o.Precedence : int.MinValue;
}

struct Operator
{
    public Operator(char symbol, int precedence, Func<bool, bool> function) : this(symbol, precedence, 1, (l, r) => function(r)) { }

    public Operator(char symbol, int precedence, Func<bool, bool, bool> function) : this(symbol, precedence, 2, function) { }

    private Operator(char symbol, int precedence, int arity, Func<bool, bool, bool> function) : this()
    {
        Symbol = symbol;
        Precedence = precedence;
        Arity = arity;
        Function = function;
    }

    public char Symbol { get; }
    public int Precedence { get; }
    public int Arity { get; }
    public Func<bool, bool, bool> Function { get; }
}

public class OperatorCollection : IEnumerable
{
    readonly IDictionary<char, Operator> operators;

    internal OperatorCollection(IDictionary<char, Operator> operators) {
        this.operators = operators;
    }

    public void Add(char symbol, int precedence, Func<bool, bool> function)
        => operators[symbol] = new Operator(symbol, precedence, function);
    public void Add(char symbol, int precedence, Func<bool, bool, bool> function)
        => operators[symbol] = new Operator(symbol, precedence, function);

    public void Remove(char symbol) => operators.Remove(symbol);

    IEnumerator IEnumerable.GetEnumerator() => operators.Values.GetEnumerator();
}

struct BitSet
{
    private int bits;

    private BitSet(int bits) { this.bits = bits; }

    public static BitSet operator ++(BitSet bitSet) => new BitSet(bitSet.bits + 1);

    public bool this[int index] => (bits & (1 << index)) != 0;
}

class Program
{
    public static void Main() {
        TruthTable tt = new TruthTable('F', 'T') {
            Operators = {
                { '!', 6, r => !r },
                { '&', 5, (l, r) => l && r },
                { '^', 4, (l, r) => l ^ r },
                { '|', 3, (l, r) => l || r }
            }
        };
        //Add a crazy operator:
        var rng = new Random();
        tt.Operators.Add('?', 6, r => rng.NextDouble() < 0.5);
        string[] expressions = {
            "!!!T",
            "?T",
            "F & x | T",
            "F & (x | T",
            "F & x | T)",
            "a ! (a & a)",
            "a | (a * a)",
            "a ^ T & (b & !c)",
        };
        foreach (string expression in expressions) {
            tt.PrintTruthTable(expression);
            Console.WriteLine();
        }

        //Define a different language
        tt = new TruthTable('0', '1') {
            Operators = {
                { '-', 6, r => !r },
                { '^', 5, (l, r) => l && r },
                { 'v', 3, (l, r) => l || r },
                { '>', 2, (l, r) => !l || r },
                { '=', 1, (l, r) => l == r },
            }
        };
        expressions = new[] {
            "-X v 0 = X ^ 1",
            "(H > M) ^ (S > H) > (S > M)"
        };
        foreach (string expression in expressions) {
            tt.PrintTruthTable(expression);
            Console.WriteLine();
        }
    }
}
