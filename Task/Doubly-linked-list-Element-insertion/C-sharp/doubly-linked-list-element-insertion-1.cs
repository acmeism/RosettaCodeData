static void InsertAfter(Link prev, int i)
{
    if (prev.next != null)
    {
        prev.next.prev = new Link() { item = i, prev = prev, next = prev.next };
        prev.next = prev.next.prev;
    }
    else
        prev.next = new Link() { item = i, prev = prev };
}
