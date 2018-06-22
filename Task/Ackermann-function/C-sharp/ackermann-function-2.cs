using System;
using System.Numerics;
using System.IO;
using System.Diagnostics;

namespace Ackermann_Function
{
    class Program
    {
        static void Main(string[] args)
        {
            int _m = 0;
            int _n = 0;
            Console.Write("m = ");
            try
            {
                _m = Convert.ToInt32(Console.ReadLine());
            }
            catch (Exception)
            {
                Console.WriteLine("Please enter a number.");
            }
            Console.Write("n = ");
            try
            {
                _n = Convert.ToInt32(Console.ReadLine());
            }
            catch (Exception)
            {
                Console.WriteLine("Please enter a number.");
            }
            //for (long m = 0; m <= 10; ++m)
            //{
            //    for (long n = 0; n <= 10; ++n)
            //    {
            //        DateTime now = DateTime.Now;
            //        Console.WriteLine("Ackermann({0}, {1}) = {2}", m, n, Ackermann(m, n));
            //        Console.WriteLine("Time taken:{0}", DateTime.Now - now);
            //    }
            //}

            DateTime now = DateTime.Now;
            Console.WriteLine("Ackermann({0}, {1}) = {2}", _m, _n, Ackermann(_m, _n));
            Console.WriteLine("Time taken:{0}", DateTime.Now - now);
            File.WriteAllText("number.txt", Ackermann(_m, _n).ToString());
            Process.Start("number.txt");
            Console.ReadKey();
        }
        public class OverflowlessStack<T>
        {
            internal sealed class SinglyLinkedNode
            {
                private const int ArraySize = 2048;
                T[] _array;
                int _size;
                public SinglyLinkedNode Next;
                public SinglyLinkedNode()
                {
                    _array = new T[ArraySize];
                }
                public bool IsEmpty { get { return _size == 0; } }
                public SinglyLinkedNode Push(T item)
                {
                    if (_size == ArraySize - 1)
                    {
                        SinglyLinkedNode n = new SinglyLinkedNode();
                        n.Next = this;
                        n.Push(item);
                        return n;
                    }
                    _array[_size++] = item;
                    return this;
                }
                public T Pop()
                {
                    return _array[--_size];
                }
            }
            private SinglyLinkedNode _head = new SinglyLinkedNode();

            public T Pop()
            {
                T ret = _head.Pop();
                if (_head.IsEmpty && _head.Next != null)
                    _head = _head.Next;
                return ret;
            }
            public void Push(T item)
            {
                _head = _head.Push(item);
            }
            public bool IsEmpty
            {
                get { return _head.Next == null && _head.IsEmpty; }
            }
        }
        public static BigInteger Ackermann(BigInteger m, BigInteger n)
        {
            var stack = new OverflowlessStack<BigInteger>();
            stack.Push(m);
            while (!stack.IsEmpty)
            {
                m = stack.Pop();
            skipStack:
                if (m == 0)
                    n = n + 1;
                else if (m == 1)
                    n = n + 2;
                else if (m == 2)
                    n = n * 2 + 3;
                else if (n == 0)
                {
                    --m;
                    n = 1;
                    goto skipStack;
                }
                else
                {
                    stack.Push(m - 1);
                    --n;
                    goto skipStack;
                }
            }
            return n;
        }
    }
}
