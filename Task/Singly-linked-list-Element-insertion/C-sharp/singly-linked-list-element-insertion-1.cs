static void InsertAfter<T>(LinkedListNode<T> prev, T value)
{
    prev.Next = new Link() { Value = value, Next = prev.Next };
}
