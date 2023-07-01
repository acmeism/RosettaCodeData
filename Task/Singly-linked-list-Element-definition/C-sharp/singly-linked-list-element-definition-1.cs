class LinkedListNode
{
    public int Value { get; set; }
    public LinkedListNode Next { get; set; }

    // A constructor is not necessary, but could be useful.
    public Link(int value, LinkedListNode next = null)
    {
        Item = value;
        Next = next;
    }
}
