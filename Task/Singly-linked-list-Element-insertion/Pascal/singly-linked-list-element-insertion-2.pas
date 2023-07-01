var
  A, B: pCharNode;
begin
  (* build the two-component list A->C manually *)
  new(A);
  A^.data := 'A';
  new(A^.next);
  A^.next^.data := 'C';
  A^.next^.next := nil;

  (* create the node to be inserted. The initialization of B^.next isn't strictly necessary
    (it gets overwritten anyway), but it's good style not to leave any values undefined. *)
  new(B);
  node^.data := 'B';
  node^.next := nil;

  (* call the above procedure to insert node B after node A *)
  InsertAfter(A, B);

  (* delete the list *)
  while A <> nil do
   begin
    B := A;
    A := A^.next;
    dispose(B);
   end
end.
