with Ada.Text_IO, Ada.Command_Line, Ada.Numerics.Discrete_Random;

procedure Flip_Bits is

   subtype Letter is Character range 'a' .. 'z';

   Last_Col: constant letter := Ada.Command_Line.Argument(1)(1);
   Last_Row: constant Positive := Positive'Value(Ada.Command_Line.Argument(2));

   package Boolean_Rand is new Ada.Numerics.Discrete_Random(Boolean);
   Gen: Boolean_Rand.Generator;

   type Matrix is array
     (Letter range 'a' .. Last_Col, Positive range 1 .. Last_Row) of Boolean;

   function Rand_Mat return Matrix is
      M: Matrix;
   begin
      for I in M'Range(1) loop
	 for J in M'Range(2) loop
	    M(I,J) := Boolean_Rand.Random(Gen);
	 end loop;
      end loop;
      return M;
   end Rand_Mat;

   function Rand_Mat(Start: Matrix) return Matrix is
      M: Matrix := Start;
   begin
      for I in M'Range(1) loop
	 if  Boolean_Rand.Random(Gen) then
	    for J in M'Range(2) loop
	       M(I,J) := not M(I, J);
	    end loop;
	 end if;
      end loop;
      for I in M'Range(2) loop
	 if  Boolean_Rand.Random(Gen) then
	    for J in M'Range(1) loop
	       M(J,I) := not M(J, I);
	    end loop;
	 end if;
      end loop;
      return M;
   end Rand_Mat;

   procedure Print(Message: String; Mat: Matrix) is
      package NIO is new Ada.Text_IO.Integer_IO(Natural);
   begin
      Ada.Text_IO.New_Line;
      Ada.Text_IO.Put_Line(Message);
      Ada.Text_IO.Put("   ");
      for Ch in Matrix'Range(1) loop
	 Ada.Text_IO.Put(" " & Ch);
      end loop;
      Ada.Text_IO.New_Line;
      for I in Matrix'Range(2) loop
	 NIO.Put(I, Width => 3);
	 for Ch in Matrix'Range(1) loop
	    Ada.Text_IO.Put(if Mat(Ch, I) then " 1" else " 0");
	 end loop;
         Ada.Text_IO.New_Line;
      end loop;
   end Print;

   Current, Target: Matrix;
   Moves: Natural := 0;

begin
   -- choose random Target and start ("Current") matrices
   Boolean_Rand.Reset(Gen);
   Target := Rand_Mat;
   loop
      Current := Rand_Mat(Target);
      exit when Current /= Target;
   end loop;
   Print("Target:", Target);

   -- print and modify Current matrix, until it is identical to Target
   while Current /= Target loop
     Moves := Moves + 1;
     Print("Current move #" & Natural'Image(Moves), Current);
      Ada.Text_IO.Put_Line("Flip row 1 .." & Positive'Image(Last_Row) &
			     " or column 'a' .. '" & Last_Col & "'");
      declare
	 S: String := Ada.Text_IO.Get_Line;
	 function Let(S: String) return Character is (S(S'First));
	 function Val(Str: String) return Positive is (Positive'Value(Str));
      begin
	 if Let(S) in 'a' .. Last_Col then
	    for I in Current'Range(2) loop
	       Current(Let(S), I) := not Current(Let(S), I);
	    end loop;
	 else
	    for I in Current'Range(1) loop
	       Current(I, Val(S)) := not Current(I, Val(S));
	    end loop;
	 end if;
      end;
   end loop;

   -- summarize the outcome
   Ada.Text_IO.Put_Line("Done after" & Natural'Image(Moves) & " Moves.");
end Flip_Bits;
