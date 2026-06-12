using System;
using System.Collections.Generic;

namespace NFARegex
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] infixes = { "a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c" };
            string[] strings = { "", "abc", "abbc", "abcc", "abad", "abbbc" };

            foreach (string infix in infixes)
            {
                foreach (string s in strings)
                {
                    bool result = MatchRegex(infix, s);
                    Console.WriteLine((result ? "True " : "False ") + infix + " " + s);
                }
                Console.WriteLine();
            }
        }

        class State
        {
            public char? Label; // Nullable char to represent character label, null for epsilon
            public State Edge1;
            public State Edge2;

            public State(char? label = null)
            {
                Label = label;
                Edge1 = null;
                Edge2 = null;
            }
        }

        class NFA
        {
            public State Initial;
            public State Accept;

            public NFA(State initial = null, State accept = null)
            {
                Initial = initial;
                Accept = accept;
            }
        }

        static string Shunt(string infix)
        {
            Dictionary<char, int> specials = new Dictionary<char, int>
            {
                { '*', 60 },
                { '+', 55 },
                { '?', 50 },
                { '.', 40 },
                { '|', 20 }
            };
            string postfix = "";
            Stack<char> stack = new Stack<char>();

            foreach (char c in infix)
            {
                if (c == '(')
                {
                    stack.Push(c);
                }
                else if (c == ')')
                {
                    while (stack.Count > 0 && stack.Peek() != '(')
                    {
                        postfix += stack.Pop();
                    }
                    if (stack.Count > 0)
                    {
                        stack.Pop(); // Remove '('
                    }
                }
                else if (specials.ContainsKey(c))
                {
                    while (stack.Count > 0 && specials.ContainsKey(stack.Peek()) && specials[c] <= specials[stack.Peek()])
                    {
                        postfix += stack.Pop();
                    }
                    stack.Push(c);
                }
                else
                {
                    postfix += c;
                }
            }

            while (stack.Count > 0)
            {
                postfix += stack.Pop();
            }

            return postfix;
        }

        static HashSet<State> Followes(State state)
        {
            HashSet<State> states = new HashSet<State>();
            Stack<State> stack = new Stack<State>();
            stack.Push(state);

            while (stack.Count > 0)
            {
                State s = stack.Pop();
                if (!states.Contains(s))
                {
                    states.Add(s);
                    if (s.Label == null) // Epsilon transition
                    {
                        if (s.Edge1 != null)
                        {
                            stack.Push(s.Edge1);
                        }
                        if (s.Edge2 != null)
                        {
                            stack.Push(s.Edge2);
                        }
                    }
                }
            }
            return states;
        }

        static NFA CompileRegex(string postfix)
        {
            Stack<NFA> nfaStack = new Stack<NFA>();

            foreach (char c in postfix)
            {
                if (c == '*')
                {
                    NFA nfa1 = nfaStack.Pop();
                    State initial = new State();
                    State accept = new State();
                    initial.Edge1 = nfa1.Initial;
                    initial.Edge2 = accept;
                    nfa1.Accept.Edge1 = nfa1.Initial;
                    nfa1.Accept.Edge2 = accept;
                    nfaStack.Push(new NFA(initial, accept));
                }
                else if (c == '.')
                {
                    NFA nfa2 = nfaStack.Pop();
                    NFA nfa1 = nfaStack.Pop();
                    nfa1.Accept.Edge1 = nfa2.Initial;
                    nfaStack.Push(new NFA(nfa1.Initial, nfa2.Accept));
                }
                else if (c == '|')
                {
                    NFA nfa2 = nfaStack.Pop();
                    NFA nfa1 = nfaStack.Pop();
                    State initial = new State();
                    State accept = new State();
                    initial.Edge1 = nfa1.Initial;
                    initial.Edge2 = nfa2.Initial;
                    nfa1.Accept.Edge1 = accept;
                    nfa2.Accept.Edge1 = accept;
                    nfaStack.Push(new NFA(initial, accept));
                }
                else if (c == '+')
                {
                    NFA nfa1 = nfaStack.Pop();
                    State initial = new State();
                    State accept = new State();
                    initial.Edge1 = nfa1.Initial;
                    nfa1.Accept.Edge1 = nfa1.Initial;
                    nfa1.Accept.Edge2 = accept;
                    nfaStack.Push(new NFA(initial, accept));
                }
                else if (c == '?')
                {
                    NFA nfa1 = nfaStack.Pop();
                    State initial = new State();
                    State accept = new State();
                    initial.Edge1 = nfa1.Initial;
                    initial.Edge2 = accept;
                    nfa1.Accept.Edge1 = accept;
                    nfaStack.Push(new NFA(initial, accept));
                }
                else // Literal character
                {
                    State initial = new State(c);
                    State accept = new State();
                    initial.Edge1 = accept;
                    nfaStack.Push(new NFA(initial, accept));
                }
            }

            return nfaStack.Pop();
        }

        static bool MatchRegex(string infix, string s)
        {
            string postfix = Shunt(infix);
            // Uncomment the next line to see the postfix expression
            // Console.WriteLine("Postfix: " + postfix);

            NFA nfa = CompileRegex(postfix);

            HashSet<State> current = Followes(nfa.Initial);
            HashSet<State> nextStates = new HashSet<State>();

            foreach (char c in s)
            {
                foreach (State state in current)
                {
                    if (state.Label == c)
                    {
                        HashSet<State> follow = Followes(state.Edge1);
                        nextStates.UnionWith(follow);
                    }
                }
                current = new HashSet<State>(nextStates);
                nextStates.Clear();
            }

            return current.Contains(nfa.Accept);
        }
    }
}
