using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace PostfixToInfix
{
    class Program
    {
        class Operator
        {
            public Operator(char t, int p, bool i = false)
            {
                Token = t;
                Precedence = p;
                IsRightAssociative = i;
            }

            public char Token { get; private set; }
            public int Precedence { get; private set; }
            public bool IsRightAssociative { get; private set; }
        }

        static IReadOnlyDictionary<char, Operator> operators = new Dictionary<char, Operator>
        {
            { '+', new Operator('+', 2) },
            { '-', new Operator('-', 2) },
            { '/', new Operator('/', 3) },
            { '*', new Operator('*', 3) },
            { '^', new Operator('^', 4, true) }
        };

        class Expression
        {
            public String ex;
            public Operator op;

            public Expression(String e)
            {
                ex = e;
            }

            public Expression(String e1, String e2, Operator o)
            {
                ex = String.Format("{0} {1} {2}", e1, o.Token, e2);
                op = o;
            }
        }

        static String PostfixToInfix(String postfix)
        {
            var stack = new Stack<Expression>();

            foreach (var token in Regex.Split(postfix, @"\s+"))
            {
                char c = token[0];

                var op = operators.FirstOrDefault(kv => kv.Key == c).Value;
                if (op != null && token.Length == 1)
                {
                    Expression rhs = stack.Pop();
                    Expression lhs = stack.Pop();

                    int opPrec = op.Precedence;

                    int lhsPrec = lhs.op != null ? lhs.op.Precedence : int.MaxValue;
                    int rhsPrec = rhs.op != null ? rhs.op.Precedence : int.MaxValue;

                    if ((lhsPrec < opPrec || (lhsPrec == opPrec && c == '^')))
                        lhs.ex = '(' + lhs.ex + ')';

                    if ((rhsPrec < opPrec || (rhsPrec == opPrec && c != '^')))
                        rhs.ex = '(' + rhs.ex + ')';

                    stack.Push(new Expression(lhs.ex, rhs.ex, op));
                }
                else
                {
                    stack.Push(new Expression(token));
                }

                // print intermediate result
                Console.WriteLine("{0} -> [{1}]", token,
                    string.Join(", ", stack.Reverse().Select(e => e.ex)));
            }
            return stack.Peek().ex;
        }

        static void Main(string[] args)
        {
            string[] inputs = { "3 4 2 * 1 5 - 2 3 ^ ^ / +", "1 2 + 3 4 + ^ 5 6 + ^" };
            foreach (var e in inputs)
            {
                Console.WriteLine("Postfix : {0}", e);
                Console.WriteLine("Infix : {0}", PostfixToInfix(e));
                Console.WriteLine(); ;
            }
            Console.ReadLine();
        }
    }
}
