class LinkedListNode<T>
{
    public T Value { get; set; }
    public LinkedListNode Next { get; set; }

    public Link(T value, LinkedListNode next = null)
    {
        Item = value;
        Next = next;
    }
}
