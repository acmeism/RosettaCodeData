program Element_insertion;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,Boost.LinkedList;

var
 List:TLinkedList<Integer>;
 Node:TLinkedListNode<Integer>;
begin
  List := TLinkedList<Integer>.Create;
  Node:= List.Add(5);
  List.AddAfter(Node,7);
  List.AddAfter(Node,15);
  Writeln(List.ToString);
  List.Free;
  Readln;
end.
