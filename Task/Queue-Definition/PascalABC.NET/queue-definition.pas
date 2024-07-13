type
  Node<T> = auto class
    data: T;
    next: Node<T>;
  end;
  MyQueue<T> = class
    head,tail: Node<T>;
  public
    procedure Enqueue(x: T);
    begin
      if tail = nil then
      begin
        tail := new Node<T>(x,nil);
        head := tail;
      end
      else
      begin
        tail.next := new Node<T>(x,nil);
        tail := tail.next;
      end;
    end;
    function Dequeue(): T;
    begin
      Result := head.data;
      head := head.Next;
      if head = nil then
        tail := nil;
    end;
    function IsEmpty: boolean := head = nil;
  end;

begin
  var q := new MyQueue<integer>;
  for var i:=1 to 5 do
    q.Enqueue(i);
  while not q.IsEmpty do
    Print(q.Dequeue);
  Print(q.IsEmpty);
end.
