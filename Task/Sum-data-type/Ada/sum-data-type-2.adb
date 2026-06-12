type Array_Type is array (Positive range <>) of Integer;

function Find_First (List  : in Array_Type; Value : in Integer) return Ret_Val
with
   Depends => (Find_First'Result => (List, Value)),
   Post    =>
   (if
      Find_First'Result.Found
    then
      Find_First'Result.Position in List'Range
      and then List (Find_First'Result.Position) = Value);
