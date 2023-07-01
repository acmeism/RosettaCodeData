static void Main()
{
    //Create A(5)->B(7)
    var A = new Link() { item = 5 };
    InsertAfter(A, 7);
    //Insert C(15) between A and B
    InsertAfter(A, 15);
}
