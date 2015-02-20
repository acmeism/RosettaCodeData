with Ada.Text_IO; use Ada.Text_IO;

procedure Overflow is

   generic
      type T is Range <>;
      Name_Of_T: String;
   procedure Print_Bounds; -- first instantiate this with T, Name
                           -- then call the instantiation
   procedure Print_Bounds is
   begin
      Put_Line("   " & Name_Of_T & " " & T'Image(T'First)
		 & " .." & T'Image(T'Last));
   end Print_Bounds;

   procedure P_Int  is new Print_Bounds(Integer,      "Integer ");
   procedure P_Nat  is new Print_Bounds(Natural,      "Natural ");
   procedure P_Pos  is new Print_Bounds(Positive,     "Positive");
   procedure P_Long is new Print_Bounds(Long_Integer, "Long    ");

   type Unsigned_Byte is range 0 .. 255;
   type Signed_Byte   is range -128 .. 127;
   type Unsigned_Word is range 0 .. 2**32-1;
   type Thousand is range 0 .. 999;
   type Signed_Double is range - 2**63 .. 2**63-1;
   type Crazy is range -11 .. -3;

   procedure P_UB is new Print_Bounds(Unsigned_Byte, "U 8  ");
   procedure P_SB is new Print_Bounds(Signed_Byte, "S 8  ");
   procedure P_UW is new Print_Bounds(Unsigned_Word, "U 32 ");
   procedure P_Th is new Print_Bounds(Thousand, "Thous");
   procedure P_SD is new Print_Bounds(Signed_Double, "S 64 ");
   procedure P_Cr is new Print_Bounds(Crazy, "Crazy");

   A: Crazy := Crazy'First;

begin
   Put_Line("Predefined Types:");
   P_Int; P_Nat; P_Pos; P_Long;
   New_Line;

   Put_Line("Types defined by the user:");
   P_UB; P_SB; P_UW; P_Th; P_SD; P_Cr;
   New_Line;

   Put_Line("Forcing a variable to overflow:");
   loop -- endless loop
      Put("  " & Crazy'Image(A) &  "+1");
      A := A + 1;
   end loop;
end Overflow;
