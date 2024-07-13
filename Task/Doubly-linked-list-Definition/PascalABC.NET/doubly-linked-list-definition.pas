type Node<T> = auto class
  data: T;
  prev,next: Node<T>;
end;

type
  MyLinkedList<T> = class
    first, last: Node<T>;
    procedure AddFirst(x: T);
    begin
      if first = nil then
      begin
        first := new Node<T>(x,nil,nil);
        last := first
      end
      else
      begin
        var p := new Node<T>(x,nil,first);
        first.prev := p;
        first := p;
      end;
    end;
    procedure AddLast(x: T);
    begin
      if first = nil then
      begin
        first := new Node<T>(x,nil,nil);
        last := first
      end
      else
      begin
        var p := new Node<T>(x,last,nil);
        last.next := p;
        last := p;
      end;
    end;
    procedure AddAfter(p: Node<T>; x: T);
    begin
      if last = p then
        AddLast(x)
      else begin
        var pp := new Node<T>(x,p,p.next);
        p.next := pp;
        pp.next.prev := pp;
      end
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
    procedure PrintBack();
    begin
      var p := last;
      while p<>nil do
      begin
        Print(p.data);
        p := p.prev;
      end;
    end;
  end;

begin
  var lst := new MyLinkedList<integer>;
  lst.AddFirst(2); lst.AddFirst(3);
  lst.AddLast(5);
  lst.AddAfter(lst.first,555);
  lst.PrintList;
  Println;
  lst.PrintBack;
end.
