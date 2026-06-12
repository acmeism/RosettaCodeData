program RevSingleLinkedList;
type
  tdata = string[15];
  tpsList = ^tsList;
  tsList = record
             data:tData;
             next : tpsList;
           end;
const
  cData: array[1..6] of string = ('Big','fjords','vex','quick','waltz','nymph');

var
  root : tpsList;

function InitLList(cnt:integer):tpsList;
var
  root,tmpList : tpsList;
  i : integer;
begin
  tmpList := new(tpsList);
  root := tmpList;
  root^.data := cData[1];
  For i := 2 to high(cData) do
  begin
    tmpList^.next := new(tpsList);
    tmpList := tmpList^.next;
    tmpList^.data := cData[i];
  end;
  tmpList^.next := NIL;
  InitLList := root;
end;

procedure OutList(root:tpsList);
begin
  while root <> NIL do
  begin
    write(root^.data,' ');
    root := root^.next;
  end;
  writeln;
end;

procedure RevList(var root:tpsList);
var
  NextinList,NewNext : tpsList;
begin
  if (root = NIL) OR (root^.next = nil) then
    EXIT;
  NextinList := root^.next;
  root^.next := NIL;
  while NextinList <> NIL do
  begin
    //memorize list element before
    NewNext := root;
    //root set to next element of root
    root := NextinList;
    //get the next in list
    NextinList := NextinList^.next;
    //correct pointer to element before
    root^.next := NewNext;
  end;
end;

procedure DeleteList(var root:tpsList);
var
  tmpList : tpsList;
begin
  while root <> nil do
  begin
    tmpList := root^.next;
    dispose(root);
    root := tmpList;
  end;
end;

begin
 root := InitLList(100);
 OutList(root);
 writeln('Reverse 3 times');
 RevList(root);OutList(root);
 RevList(root);OutList(root);
 RevList(root);OutList(root);
 DeleteList(root);
 OutList(root);
end.
