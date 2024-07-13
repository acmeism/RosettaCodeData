type Node<T> = auto class
  data: T;
  left,right: Node<T>;
end;

function CreateTree(n: integer): Node<integer>;
begin
  if n = 0 then
    Result := nil
  else
    Result := new Node<integer>(
      Random(100),
      CreateTree((n-1) div 2),
      CreateTree(n-1 - (n-1) div 2)
    );
end;

procedure InfixTraverse<T>(root: Node<T>; act: T -> ());
begin
  if root = nil then
    exit;
  InfixTraverse(root.left,act);
  act(root.data);
  InfixTraverse(root.right,act);
end;

begin
  var tree := CreateTree(10);
  Println(tree);
  InfixTraverse(tree, x -> Print(x));
end.
