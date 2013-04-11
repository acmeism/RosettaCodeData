type
  pCharNode = ^CharNode;
  CharNode = record
               data: char;
               next: pCharNode;
             end;

(* This procedure inserts a node (newnode) directly after another node which is assumed to already be in a list.
  It does not allocate a new node, but takes an already allocated node, thus allowing to use it (together with
  a procedure to remove a node from a list) for splicing a node from one list to another. *)
procedure InsertAfter(listnode, newnode: pCharNode);
begin
  newnode^.next := listnode^.next;
  listnode^.next := newnode;
end;
