package body Generic_Puzzle is

   Field: array(Row_Type, Col_Type) of Natural;
   Current_R: Row_Type := Rows;
   Current_C: Col_Type := Cols;
   -- invariant: Field(Current_R, Current_C=0)
   -- and for all R, C: Field(R, C) < R*C
   -- and for all (R, C) /= (RR, CC): Field(R, C) /= Field(RR, CC)

   function Get_Point(Row: Row_Type; Col: Col_Type) return String is
      (Name(Field(Row, Col)));

   function Possible return Move_Arr is
      (Up => Current_R > 1, Down => Current_R < Rows,
       Left => Current_C > 1, Right => Current_C < Cols);

   procedure Move(The_Move: Moves) is
      Old_R: Row_Type; Old_C: Col_Type; N: Natural;
   begin
      if not Possible(The_Move) then
	 raise Constraint_Error with "attempt to make impossible move";
      else
	 -- remember current row and column
	 Old_R := Current_R;
	 Old_C := Current_C;
	
	 -- move the virtual cursor to a new position
	 case The_Move is
	   when Up    => Current_R := Current_R - 1;
	   when Down  => Current_R := Current_R + 1;
	   when Left  => Current_C := Current_C - 1;
	   when Right => Current_C := Current_C + 1;
	 end case;
	
	 -- swap the tiles on the board
	 N := Field(Old_R, Old_C);
	 Field(Old_R, Old_C) := Field(Current_R, Current_C);
	 Field(Current_R, Current_C) := N;
      end if;
   end Move;

begin
   declare   -- set field to its basic setting
      N: Positive := 1;
   begin
      for R in Row_Type loop
	 for C in Col_Type loop
	    if (R /= Current_R) or else (C /= Current_C) then
	       Field(R, C) := N;
	       N := N + 1;
	    else
	       Field(R, C) := 0;
	    end if;
	 end loop;
      end loop;
   end;
end Generic_Puzzle;
