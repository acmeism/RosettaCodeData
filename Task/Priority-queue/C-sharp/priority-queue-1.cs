using System;

namespace PriorityQueue
{
    class Program
    {
        static void Main(string[] args)
        {
            PriorityQueue PQ = new PriorityQueue();
            PQ.push(3, "Clear drains");
            PQ.push(4, "Feed cat");
            PQ.push(5, "Make tea");
            PQ.push(1, "Solve RC tasks");
            PQ.push(2, "Tax return");

            while (!PQ.Empty)
            {
                var Val = PQ.pop();
                Console.WriteLine(Val[0] + " : " + Val[1]);
            }
            Console.ReadKey();
        }
    }

    class PriorityQueue
    {
        private System.Collections.SortedList PseudoQueue;

        public bool Empty
        {
            get
            {
                return PseudoQueue.Count == 0;
            }
        }

        public PriorityQueue()
        {
            PseudoQueue = new System.Collections.SortedList();
        }

        public void push(object Priority, object Value)
        {
            PseudoQueue.Add(Priority, Value);
        }

        public object[] pop()
        {
            object[] ReturnValue = { null, null };
            if (PseudoQueue.Count > 0)
            {
                ReturnValue[0] = PseudoQueue.GetKey(0);
                ReturnValue[1] = PseudoQueue.GetByIndex(0);

                PseudoQueue.RemoveAt(0);
            }
            return ReturnValue;
        }
    }
}
