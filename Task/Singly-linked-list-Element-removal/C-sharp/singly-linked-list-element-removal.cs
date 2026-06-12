using System;
using System.Runtime.InteropServices;

static unsafe class Program
{
    ref struct LinkedListNode
    {
        public int Value;
        public LinkedListNode* Next;
        public override string ToString() => this.Value + (this.Next == null ? string.Empty : " -> " + this.Next->ToString());
    }

    static void Remove(LinkedListNode** head, LinkedListNode* entry)
    {
        // The "indirect" pointer points to the
        // *address* of the thing we'll update

        LinkedListNode** indirect = head;

        // Walk the list, looking for the thing that
        // points to the entry we want to remove

        while (*indirect != entry)
            indirect = &(*indirect)->Next;

        // .. and just remove it
        *indirect = entry->Next;
    }

    static void Main()
    {
        // Allocate like real C!
        var head = (LinkedListNode*)Marshal.AllocHGlobal(sizeof(LinkedListNode));
        head->Value = 1;
        head->Next = (LinkedListNode*)Marshal.AllocHGlobal(sizeof(LinkedListNode));
        head->Next->Value = 2;
        head->Next->Next = null;

        LinkedListNode copy = *head;

        Console.WriteLine("original:                    " + head->ToString());

        Remove(&head, head);
        Console.WriteLine("after removing head:         " + head->ToString());

        head = &copy;
        Console.WriteLine("restored from copy:          " + head->ToString());

        Remove(&head, head->Next);
        Console.WriteLine("after removing second node:  " + head->ToString());
    }
}
