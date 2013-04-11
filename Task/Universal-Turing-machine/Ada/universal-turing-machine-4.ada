with Ada.Text_IO, Turing;

procedure Busy_Beaver_3 is

   type States is (A, B, C, Stop);
   type Symbols is range 0 .. 1;
   package UTM is new Turing(States, Symbols); use UTM;

   Map: Symbol_Map := (1 => '1', 0 => '0');

   Rules: Rules_Type :=
     (A => (0 => (New_State => B, Move_To => Right, New_Symbol => 1),
            1 => (New_State => C, Move_To => Left,  New_Symbol => 1)),
      B => (0 => (New_State => A, Move_To => Left,  New_Symbol => 1),
            1 => (New_State => B, Move_To => Right, New_Symbol => 1)),
      C => (0 => (New_State => B, Move_To => Left,  New_Symbol => 1),
            1 => (New_State => Stop, Move_To => Stay, New_Symbol => 1)));

   Tape:  Tape_Type := To_Tape("", Map);

   procedure Put_Tape(Tape: Tape_Type; Current: States) is
   begin
      Ada.Text_IO.Put_Line(To_String(Tape, Map) & "  " &
                             States'Image(Current));
      Ada.Text_IO.Put_Line(Position_To_String(Tape));
   end Put_Tape;

begin
   Run(Tape, Rules, 20, Put_Tape'Access); -- print configuration before each step
   Put_Tape(Tape, Stop);                  -- and print the final configuration
end Busy_Beaver_3;
