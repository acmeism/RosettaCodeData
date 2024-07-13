type
  Node<T> = auto class
    data: T;
    left,right: Node<T>;
  end;

function ND<T>(data: T; left: Node<T> := nil; right: Node<T> := nil)
  := new Node<T>(data,left,right);

procedure Prefix<T>(r: Node<T>);
begin
  if r = nil then
    exit;
  Print(r.data);
  Prefix(r.left);
  Prefix(r.right);
end;

procedure Infix<T>(r: Node<T>);
begin
  if r = nil then
    exit;
  Infix(r.left);
  Print(r.data);
  Infix(r.right);
end;

procedure Postfix<T>(r: Node<T>);
begin
  if r = nil then
    exit;
  Postfix(r.left);
  Postfix(r.right);
  Print(r.data);
end;

procedure LevelOrder<T>(r: Node<T>);
begin
  if r = nil then
    exit;
  var q := new Queue<Node<T>>;
  q.Enqueue(r);
  while q.Count > 0 do
  begin
    var x := q.Dequeue;
    Print(x.data);
    if x.left <> nil then
      q.Enqueue(x.Left);
    if x.Right <> nil then
      q.Enqueue(x.Right);
  end;
end;

begin
  var root := ND(1,ND(2,ND(4,ND(7)),ND(5)),ND(3,ND(6,ND(8),ND(9))));
  Println(root);
  Prefix(root); Println;
  Infix(root); Println;
  Postfix(root); Println;
  LevelOrder(root); Println;
end.
