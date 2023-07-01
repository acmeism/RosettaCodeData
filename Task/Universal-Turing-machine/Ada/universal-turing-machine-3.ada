with Ada.Text_IO, Turing;

procedure Simple_Incrementer is

   type States is (Start, Stop);
   type Symbols is (Blank, One);

   package UTM is new Turing(States, Symbols);
   use UTM;

   Map: Symbol_Map := (One => '1', Blank => '_');

   Rules: Rules_Type :=
     (Start => (One   => (Start, Right,  One),
                Blank => (Stop,  Stay,  One)));
   Tape:  Tape_Type := To_Tape("111", Map);

   procedure Put_Tape(Tape: Tape_Type; Current: States) is
   begin
     Ada.Text_IO.Put_Line(To_String(Tape, Map) & "  " & States'Image(Current));
     Ada.Text_IO.Put_Line(Position_To_String(Tape));
   end Put_Tape;

begin
   Run(Tape, Rules, 20, null); -- don't print the configuration during running
   Put_Tape(Tape, Stop);       -- print the final configuration
end Simple_Incrementer;
