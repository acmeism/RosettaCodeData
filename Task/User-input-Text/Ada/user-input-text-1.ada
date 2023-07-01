function Get_String return String is
  Line : String (1 .. 1_000);
  Last : Natural;
begin
  Get_Line (Line, Last);
  return Line (1 .. Last);
end Get_String;

function Get_Integer return Integer is
  S : constant String := Get_String;
begin
  return Integer'Value (S);
  --  may raise exception Constraint_Error if value entered is not a well-formed integer
end Get_Integer;
