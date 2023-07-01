{Structure holding node data}

type PNode = ^TNode;
 TNode = record
 Data: integer;
 Left,Right: PNode;
 end;


function PreOrder(Node: TNode): string;
{Recursively traverse Node-Left-Right}
begin
Result:=IntToStr(Node.Data);
if Node.Left<>nil then Result:=Result+' '+PreOrder(Node.Left^);
if Node.Right<>nil then Result:=Result+' '+PreOrder(Node.Right^);
end;


function InOrder(Node: TNode): string;
{Recursively traverse Left-Node-Right}
begin
Result:='';
if Node.Left<>nil then Result:=Result+inOrder(Node.Left^);
Result:=Result+IntToStr(Node.Data)+' ';
if Node.Right<>nil then Result:=Result+inOrder(Node.Right^);
end;


function PostOrder(Node: TNode): string;
{Recursively traverse Left-Right-Node}
begin
Result:='';
if Node.Left<>nil then Result:=Result+PostOrder(Node.Left^);
if Node.Right<>nil then Result:=Result+PostOrder(Node.Right^);
Result:=Result+IntToStr(Node.Data)+' ';
end;


function LevelOrder(Node: TNode): string;
{Traverse the tree at each level, Left to right}
var Queue: TList;
var NT: TNode;
begin
Queue:=TList.Create;
try
Result:='';
Queue.Add(@Node);
while true do
	begin
	{Display oldest node in queue}
	NT:=PNode(Queue[0])^;
	Queue.Delete(0);
	Result:=Result+IntToStr(NT.Data)+' ';
	{Queue left and right children}
	if NT.left<>nil then Queue.add(NT.left);
	if NT.right<>nil then Queue.add(NT.right);
	if Queue.Count<1 then break;
        end;
finally Queue.Free; end;
end;


procedure ShowBinaryTree(Memo: TMemo);
var Tree: array [0..9] of TNode;
var I: integer;
begin
{Fill array of node with data}
{that matchs its position in the array}
for I:=0 to High(Tree) do
	begin
	Tree[I].Data:=I+1;
	Tree[I].Left:=nil;
	Tree[I].Right:=nil;
	end;
{Build the specified tree}
Tree[0].left:=@Tree[2-1];
Tree[0].right:=@Tree[3-1];
Tree[1].left:=@Tree[4-1];
Tree[1].right:=@Tree[5-1];
Tree[3].left:=@Tree[7-1];
Tree[2].left:=@Tree[6-1];
Tree[5].left:=@Tree[8-1];
Tree[5].right:=@Tree[9-1];
{Tranverse the tree in four specified ways}
Memo.Lines.Add('Pre-Order:   '+PreOrder(Tree[0]));
Memo.Lines.Add('In-Order:    '+InOrder(Tree[0]));
Memo.Lines.Add('Post-Order:  '+PostOrder(Tree[0]));
Memo.Lines.Add('Level-Order: '+LevelOrder(Tree[0]));
end;
