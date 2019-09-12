using System.Collections.Generic;

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
