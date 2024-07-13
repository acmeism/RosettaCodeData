type Node<T> = auto class
  data: T;
  prev,next: Node<T>;
end;

type
  MyLinkedList<T> = class
    first, last: Node<T>;
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
        pp.prev.next := pp;
      end
    end;
  end;
