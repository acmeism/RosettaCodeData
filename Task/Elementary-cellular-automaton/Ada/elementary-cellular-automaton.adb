with Ada.Text_IO;
procedure Elementary_Cellular_Automaton is

   type t_Rule  is new Integer range 0..2**8-1;
   type t_State is array (Integer range <>) of Boolean;

   Cell_Image : constant array (Boolean) of Character := ('.', '#');

   function Image (State : in t_State) return String is
     (Cell_Image(State(State'First)) &
      (if State'Length <= 1 then ""
       else Image(State(State'First+1..State'Last))));

   -- More convenient representation of the rule
   type t_RuleA is array (Boolean, Boolean, Boolean) of Boolean;

   function Translate (Rule : in t_Rule) return t_RuleA is
      -- Better not use Pack attribute and Unchecked_Conversion
      -- because it would not be endianness independent...
      Remain : t_Rule := Rule;
   begin
      return Answer : t_RuleA do
         for K in Boolean loop
            for J in Boolean loop
               for I in Boolean loop
                  Answer(I,J,K) := (Remain mod 2 = 1);
                  Remain := Remain / 2;
               end loop;
            end loop;
         end loop;
      end return;
   end Translate;

   procedure Show_Automaton (Rule        : in t_Rule;
                             Initial     : in t_State;
                             Generations : in Positive) is
      RuleA : constant t_RuleA  := Translate(Rule);
      Width : constant Positive := Initial'Length;
      -- More convenient indices for neighbor wraparound with "mod"
      subtype t_State0 is t_State (0..Width-1);
      State     : t_State0 := Initial;
      New_State : t_State0;
   begin
      Ada.Text_IO.Put_Line ("Rule" & t_Rule'Image(Rule) & " :");
      for Generation in 1..Generations loop
         Ada.Text_IO.Put_Line (Image(State));
         for Cell in State'Range loop
            New_State(Cell) := RuleA(State((Cell-1) mod Width),
                                     State(Cell),
                                     State((Cell+1) mod Width));
         end loop;
         State := New_State;
      end loop;
   end Show_Automaton;

begin
   Show_Automaton (Rule        => 90,
                   Initial     => (-10..-1 => False, 0 => True, 1..10 => False),
                   Generations => 15);
   Show_Automaton (Rule        => 30,
                   Initial     => (-15..-1 => False, 0 => True, 1..15 => False),
                   Generations => 20);
   Show_Automaton (Rule        => 122,
                   Initial     => (-12..-1 => False, 0 => True, 1..12 => False),
                   Generations => 25);
end Elementary_Cellular_Automaton;
