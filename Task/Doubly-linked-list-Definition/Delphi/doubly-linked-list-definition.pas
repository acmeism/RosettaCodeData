program Doubly_linked;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  boost.LinkedList;

var
  List: TLinkedList<string>;
  Head, Tail,Current: TLinkedListNode<string>;
  Value:string;

begin
  List := TLinkedList<string>.Create;

  List.AddFirst('.AddFirst() adds at the head.');
  List.AddLast('.AddLast() adds at the tail.');
  Head := List.Find('.AddFirst() adds at the head.');
  List.AddAfter(Head, '.AddAfter() adds after a specified node.');
  Tail := List.Find('.AddLast() adds at the tail.');
  List.AddBefore(Tail, 'Betcha can''t guess what .AddBefore() does.');

  Writeln('Forward:');
  for value in List do
    Writeln(value);

  Writeln(#10'Backward:');

  Current:= Tail;
  while Assigned(Current) do
  begin
    Writeln(Current.Value);
    Current:= Current.Prev;
  end;

  List.Free;
  Readln;
end.
