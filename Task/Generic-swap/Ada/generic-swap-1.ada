generic
   type Swap_Type is private; -- Generic parameter
procedure Generic_Swap(Left : in out Swap_Type; Right : in out Swap_Type);

procedure Generic_Swap(Left : in out Swap_Type; Right : in out Swap_Type) is
   Temp : Swap_Type := Left;
begin
   Left := Right;
   Right := Temp;
end Generic_Swap;
