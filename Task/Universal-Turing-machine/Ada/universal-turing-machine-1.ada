private with Ada.Containers.Doubly_Linked_Lists;

generic
   type State is (<>);   -- State'First is starting state
   type Symbol is (<>);  -- Symbol'First is blank
package Turing is

   Start: constant State := State'First;
   Halt:  constant State := State'Last;
   subtype Action_State is State range Start .. State'Pred(Halt);

   Blank: constant Symbol := Symbol'First;

   type Movement is (Left, Stay, Right);

   type Action is record
      New_State: State;
      Move_To: Movement;
      New_Symbol: Symbol;
   end record;

   type Rules_Type is array(Action_State, Symbol) of Action;

   type Tape_Type is limited private;

   type Symbol_Map is array(Symbol) of Character;

   function To_String(Tape: Tape_Type; Map: Symbol_Map) return String;
   function Position_To_String(Tape: Tape_Type; Marker: Character := '^')
                              return String;
   function To_Tape(Str: String; Map: Symbol_Map) return Tape_Type;

   procedure Single_Step(Current: in out State;
                         Tape: in out Tape_Type;
                         Rules: Rules_Type);

   procedure Run(The_Tape: in out Tape_Type;
                 Rules: Rules_Type;
                 Max_Steps: Natural := Natural'Last;
                 Print: access procedure(Tape: Tape_Type; Current: State));
   -- runs from Start State until either Halt or # Steps exceeds Max_Steps
   -- if # of steps exceeds Max_Steps, Constrained_Error is raised;
   -- if Print is not null, Print is called at the beginning of each step

private
   package Symbol_Lists is new Ada.Containers.Doubly_Linked_Lists(Symbol);
   subtype List is Symbol_Lists.List;

   type Tape_Type is record
      Left:  List;
      Here:  Symbol;
      Right: List;
   end record;
end Turing;
