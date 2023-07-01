package body Turing is

   function List_To_String(L: List; Map: Symbol_Map) return String is
      LL: List := L;
      use type List;
   begin
      if L = Symbol_Lists.Empty_List then
         return "";
      else
         LL.Delete_First;
         return Map(L.First_Element) & List_To_String(LL, Map);
      end if;
   end List_To_String;

   function To_String(Tape: Tape_Type; Map: Symbol_Map) return String is

   begin
      return List_To_String(Tape.Left, Map) & Map(Tape.Here) &
        List_To_String(Tape.Right, Map);
   end To_String;

   function Position_To_String(Tape: Tape_Type; Marker: Character := '^')
                              return String is
      Blank_Map: Symbol_Map := (others => ' ');
   begin
      return List_To_String(Tape.Left, Blank_Map) & Marker &
        List_To_String(Tape.Right, Blank_Map);
   end Position_To_String;

   function To_Tape(Str: String; Map: Symbol_Map) return Tape_Type is
      Char_Map: array(Character) of Symbol := (others => Blank);
      Tape: Tape_Type;
   begin
      if Str = "" then
         Tape.Here := Blank;
      else
         for S in Symbol loop
            Char_Map(Map(S)) := S;
         end loop;
         Tape.Here := Char_Map(Str(Str'First));
         for I in Str'First+1 .. Str'Last loop
            Tape.Right.Append(Char_Map(Str(I)));
         end loop;
      end if;
      return Tape;
      end To_Tape;

   procedure Single_Step(Current: in out State;
                         Tape: in out Tape_Type;
                         Rules: Rules_Type) is
      Act: Action := Rules(Current, Tape.Here);
      use type List; -- needed to compare Tape.Left/Right to the Empty_List
   begin
      Current := Act.New_State;     -- 1. update State
      Tape.Here := Act.New_Symbol;  -- 2. write Symbol to Tape
      case Act.Move_To is           -- 3. move Tape to the Left/Right or Stay
         when Left =>
            Tape.Right.Prepend(Tape.Here);
            if Tape.Left /= Symbol_Lists.Empty_List then
               Tape.Here := Tape.Left.Last_Element;
               Tape.Left.Delete_Last;
            else
               Tape.Here := Blank;
            end if;
        when Stay =>
            null; -- Stay where you are!
         when Right =>
            Tape.Left.Append(Tape.Here);
            if Tape.Right /= Symbol_Lists.Empty_List then
               Tape.Here := Tape.Right.First_Element;
               Tape.Right.Delete_First;
            else
               Tape.Here := Blank;
            end if;
      end case;
   end Single_Step;

   procedure Run(The_Tape: in out Tape_Type;
                 Rules: Rules_Type;
                 Max_Steps: Natural := Natural'Last;
                 Print: access procedure (Tape: Tape_Type; Current: State)) is
      The_State: State     := Start;
      Steps:     Natural   := 0;
   begin
      Steps := 0;
      while (Steps <= Max_Steps) and (The_State /= Halt) loop
         if Print /= null then
            Print(The_Tape, The_State);
         end if;
         Steps := Steps + 1;
         Single_Step(The_State, The_Tape, Rules);
      end loop;
      if The_State /= Halt then
         raise Constraint_Error;
      end if;
   end Run;

end Turing;
