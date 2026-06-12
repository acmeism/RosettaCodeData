program doublylinkedlist;

type
  pDbllist = ^tDbllist;
  tDbllist = record
    data: integer;
    prev, next: pDbllist;
  end;

procedure add(var tail: pDbllist; data: integer);
var
  cur: pDbllist;
begin
  new(cur);
  cur^.data := data;
  cur^.prev := tail;
  cur^.next := nil;
  if tail <> nil then
    tail^.next := cur;
  tail := cur;
end;

procedure delete(var head, tail: pDbllist; data: integer);
var
  cur: pDbllist;
begin
  cur := head;
  while (cur <> nil) and (cur^.data <> data) do
    cur := cur^.next;

  if cur = nil then
    exit; // data not found

  if cur^.prev = nil then // cur is the head
  begin
    head := cur^.next;
    if head <> nil then
      head^.prev := nil
    else
      tail := nil; // list becomes empty
  end
  else if cur^.next = nil then // cur is the tail
  begin
    tail := cur^.prev;
    tail^.next := nil;
  end
  else // cur is in the middle
  begin
    cur^.prev^.next := cur^.next;
    cur^.next^.prev := cur^.prev;
  end;

  dispose(cur);
end;

procedure destroyList(var head: pDbllist);
var
  cur, next: pDbllist;
begin
  cur := head;
  while cur <> nil do
  begin
    next := cur^.next;
    dispose(cur);
    cur := next;
  end;
  head := nil;
end;

procedure display(head: pDbllist);
var
  cur: pDbllist;
begin
  cur := head;
  while cur <> nil do
  begin
    writeln(cur^.data);
    cur := cur^.next;
  end;
end;

var
  head, tail: pDbllist;
  i: integer;
begin
  head := nil;
  tail := nil;

  // Initial list setup
  for i := 1 to 5 do
  begin
    if tail = nil then
    begin
      new(head);
      head^.data := i;
      head^.prev := nil;
      head^.next := nil;
      tail := head;
    end
    else
    begin
      add(tail, i);
    end;
  end;

  writeln('Original list:');
  display(head);

  writeln('Deleting 3:');
  delete(head, tail, 3);
  display(head);

  writeln('Deleting 1 (head):');
  delete(head, tail, 1);
  display(head);

  writeln('Deleting 5 (tail):');
  delete(head, tail, 5);
  display(head);

  writeln('Destroying list!');
  destroyList(head);
  display(head); // should display nothing as the list is destroyed
end.

