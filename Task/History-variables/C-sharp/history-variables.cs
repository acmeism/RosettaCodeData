using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace History
{
    class Program
    {
        static void Main(string[] args)
        {
            var h = new HistoryObject();
            h.Value = 5;
            h.Value = "foo";
            h.Value += "bar";

            var history = h.ToArray();

            for (int i = 0; i < history.Length; i++)
            {
                Console.Write("{0}{1}", history[i], ((i >= history.Length - 1) ? "\n" : " <- "));
            }

            h.Undo();
            h.Undo();
            h.Undo();

            Console.WriteLine(h.Value);
        }

        private class HistoryObject : IEnumerable<object>
        {
            public HistoryObject()
            {
                _history = new Stack<object>(); // Initiates the history stack.
            }

            public object Value
            {
                get // Returns the top value from the history if there is one. Otherwise null.
                {
                    if (_history.Count > 0)
                        return _history.Peek();
                    return null;
                }
                set { _history.Push(value); } // Adds the specified value to the history.
            }

            public void Undo()
            {
                if (_history.Count > 0)
                    _history.Pop(); // Removes the current value from the history.
            }

            // History stack that will hold all previous values of the object.
            private readonly Stack<object> _history;

            public IEnumerator<object> GetEnumerator()
            {
                return _history.GetEnumerator();
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return GetEnumerator();
            }
        }
    }
}
