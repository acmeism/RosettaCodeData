static void Main()
{
    //Create A(5)->B(7)
    var A = new LinkedListNode<int>() { Value = 5 };
    InsertAfter(A, 7);
    //Insert C between A and B
    InsertAfter(A, 15);
}
