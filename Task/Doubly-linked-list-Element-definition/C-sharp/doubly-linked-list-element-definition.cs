class Link
{
    public int Item { get; set; }
    public Link Prev { get; set; }
    public Link Next { get; set; }

    //A constructor is not neccessary, but could be useful
    public Link(int item, Link prev = null, Link next = null) {
        Item = item;
        Prev = prev;
        Next = next;
    }
}
