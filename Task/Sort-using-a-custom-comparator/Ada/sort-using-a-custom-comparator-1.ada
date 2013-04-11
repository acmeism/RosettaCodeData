with Ada.Text_Io; use Ada.Text_Io;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Gnat.Heap_Sort_G;

procedure Custom_Compare is

   type StringArrayType is array (Natural range <>) of Unbounded_String;

   Strings : StringArrayType := (Null_Unbounded_String,
                                 To_Unbounded_String("this"),
                                 To_Unbounded_String("is"),
                                 To_Unbounded_String("a"),
                                 To_Unbounded_String("set"),
                                 To_Unbounded_String("of"),
                                 To_Unbounded_String("strings"),
                                 To_Unbounded_String("to"),
                                 To_Unbounded_String("sort"),
                                 To_Unbounded_String("This"),
                                 To_Unbounded_String("Is"),
                                 To_Unbounded_String("A"),
                                 To_Unbounded_String("Set"),
                                 To_Unbounded_String("Of"),
                                 To_Unbounded_String("Strings"),
                                 To_Unbounded_String("To"),
                                 To_Unbounded_String("Sort"));

   procedure Move (From, To : in Natural) is

   begin
      Strings(To) := Strings(From);
   end Move;

   function UpCase (Char : in Character) return Character is
      Temp : Character;
   begin
      if Char >= 'a' and Char <= 'z' then
         Temp := Character'Val(Character'Pos(Char)
                                 - Character'Pos('a')
                                 + Character'Pos('A'));
      else
         Temp := Char;
      end if;
      return Temp;
   end UpCase;

   function Lt (Op1, Op2 : Natural)
               return Boolean is
      Temp, Len : Natural;
   begin
      Len := Length(Strings(Op1));
      Temp := Length(Strings(Op2));
      if Len < Temp then
         return False;
      elsif Len > Temp then
         return True;
      end if;

      declare
         S1, S2 : String(1..Len);
      begin
         S1 := To_String(Strings(Op1));
         S2 := To_String(Strings(Op2));
      Put("Same size:  ");
      Put(S1);
      Put(" ");
      Put(S2);
      Put(" ");
      for I in S1'Range loop
         Put(UpCase(S1(I)));
         Put(UpCase(S2(I)));
         if UpCase(S1(I)) = UpCase(S2(I)) then
           null;
         elsif UpCase(S1(I)) < UpCase(S2(I)) then
            Put(" LT");
            New_Line;
            return True;
         else
            return False;
         end if;
      end loop;
      Put(" GTE");
      New_Line;
      return False;
      end;
   end Lt;

   procedure Put (Arr : in StringArrayType) is
   begin
      for I in 1..Arr'Length-1 loop
         Put(To_String(Arr(I)));
         New_Line;
      end loop;
   end Put;

   package Heap is new Gnat.Heap_Sort_G(Move,
                                        Lt);
   use Heap;


begin
   Put_Line("Unsorted list:");
   Put(Strings);
   New_Line;
   Sort(16);
   New_Line;
   Put_Line("Sorted list:");
   Put(Strings);
end Custom_Compare;
