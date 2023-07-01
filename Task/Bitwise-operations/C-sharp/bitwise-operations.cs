static void bitwise(int a, int b)
        {
            Console.WriteLine("a and b is {0}", a & b);
            Console.WriteLine("a or b is {0}", a | b);
            Console.WriteLine("a xor b is {0}", a ^ b);
            Console.WriteLine("not a is {0}", ~a);
            Console.WriteLine("a lshift b is {0}", a << b);
            Console.WriteLine("a arshift b is {0}", a >> b); // When the left operand of the >> operator is of a signed integral type,
                                                             // the operator performs an arithmetic shift right
            uint c = (uint)a;
            Console.WriteLine("c rshift b is {0}", c >> b); // When the left operand of the >> operator is of an unsigned integral type,
                                                            // the operator performs a logical shift right
            // there are no rotation operators in C#
        }
