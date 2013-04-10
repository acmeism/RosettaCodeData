using System.Collections.Generic;
namespace Doubly_Linked_List
{
    class Program
    {
        static void Main(string[] args)
        {
            LinkedList<string> list = new LinkedList<string>();
            list.AddFirst(".AddFirst() adds at the head.");
            list.AddLast(".AddLast() adds at the tail.");
            LinkedListNode<string> head = list.Find(".AddFirst() adds at the head.");
            list.AddAfter(head, ".AddAfter() adds after a specified node.");
            LinkedListNode<string> tail = list.Find(".AddLast() adds at the tail.");
            list.AddBefore(tail, "Betcha can't guess what .AddBefore() does.");

            System.Console.WriteLine("Forward:");
            foreach (string nodeValue in list) { System.Console.WriteLine(nodeValue); }

            System.Console.WriteLine("\nBackward:");
            LinkedListNode<string> current = tail;
            while (current != null)
            {
                System.Console.WriteLine(current.Value);
                current = current.Previous;
            }
        }
    }
}

/* Output:
	Forward:
	.AddFirst() adds at the head.
	.AddAfter() adds after a specified node.
	Betcha can't guess what .AddBefore() does.
	.AddLast() adds at the tail.

	Backward:
	.AddLast() adds at the tail.
	Betcha can't guess what .AddBefore() does.
	.AddAfter() adds after a specified node.
	.AddFirst() adds at the head.
*/
