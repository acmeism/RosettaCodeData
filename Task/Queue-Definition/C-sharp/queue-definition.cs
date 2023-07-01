public class FIFO<T>
{
  class Node
  {
    public T Item { get; set; }
    public Node Next { get; set; }
  }
  Node first = null;
  Node last = null;
  public void push(T item)
  {
    if (empty())
    {
      //Uses object initializers to set fields of new node
      first = new Node() { Item = item, Next = null };
      last = first;
    }
    else
    {
      last.Next = new Node() { Item = item, Next = null };
      last = last.Next;
    }
  }
  public T pop()
  {
    if (first == null)
      throw new System.Exception("No elements");
    if (last == first)
      last = null;
    T temp = first.Item;
    first = first.Next;
    return temp;
  }
  public bool empty()
  {
    return first == null;
  }
}
