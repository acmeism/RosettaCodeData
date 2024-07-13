type Node<T> = auto class
  data: T;
  next: Node<T>;
end;

type
  SinglyLinkedList<T> = class
    first: Node<T>;
    procedure AddFirst(x: T);
    begin
      first := new Node<T>(x,first);
    end;
    procedure AddAfter(p: Node<T>; x: T);
    begin
      p.next := new Node<T>(x,p.next);
    end;
    procedure PrintList();
    begin
      var p := first;
      while p<>nil do
      begin
        Print(p.data);
        p := p.next;
      end;
    end;
  end;

begin
  var lst := new SinglyLinkedList<integer>;
  lst.AddFirst(2); lst.AddFirst(3);
  lst.AddAfter(lst.first,555);
  lst.PrintList;
end.
