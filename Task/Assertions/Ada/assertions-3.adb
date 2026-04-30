procedure Find_First
     (List     : in     Array_Type;
      Value    : in     Integer;
      Found    :    out Boolean;
      Position :    out Positive) with
      Depends => ((Found, Position) => (List, Value)),
      Pre     => (List'Length > 0),
      Post    =>
      (if Found then Position in List'Range and then List (Position) = Value
       else Position = List'Last);
