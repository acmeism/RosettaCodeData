with Ada.Command_Line;
with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Strings.Maps;
with Ada.Strings.Fixed;
with Ada.Characters.Handling;
with Ada.Containers.Indefinite_Ordered_Maps;
with Ada.Containers.Indefinite_Ordered_Sets;
with Ada.Containers.Ordered_Maps;

procedure Word_Frequency is
    package TIO renames Ada.Text_IO;

    package String_Counters is new Ada.Containers.Indefinite_Ordered_Maps(String, Natural);
    package String_Sets is new Ada.Containers.Indefinite_Ordered_Sets(String);
    package Sorted_Counters is new Ada.Containers.Ordered_Maps
      (Natural,
       String_Sets.Set,
       "=" => String_Sets."=",
       "<" => ">");
    -- for sorting by decreasing number of occurrences and ascending lexical order

    procedure Increment(Key : in String; Element : in out Natural) is
    begin
        Element := Element + 1;
    end Increment;

    path : constant String := Ada.Command_Line.Argument(1);
    how_many : Natural := 10;
    set : constant Ada.Strings.Maps.Character_Set := Ada.Strings.Maps.To_Set(ranges => (('a', 'z'), ('0', '9')));
    F : TIO.File_Type;
    first : Positive;
    last : Natural;
    from : Positive;
    counter : String_Counters.Map;
    sorted_counts : Sorted_Counters.Map;
    C1 : String_Counters.Cursor;
    C2 : Sorted_Counters.Cursor;
    tmp_set : String_Sets.Set;
begin
    -- read file and count words
    TIO.Open(F, name => path, mode => TIO.In_File);
    while not TIO.End_Of_File(F) loop
       declare
          line : constant String := Ada.Characters.Handling.To_Lower(TIO.Get_Line(F));
       begin
          from := line'First;
          loop
             Ada.Strings.Fixed.Find_Token(line(from .. line'Last), set, Ada.Strings.Inside, first, last);
             exit when last < First;
             C1 := counter.Find(line(first .. last));
             if String_Counters.Has_Element(C1) then
                counter.Update_Element(C1, Increment'Access);
             else
                counter.Insert(line(first .. last), 1);
             end if;
             from := last + 1;
          end loop;
       end;
    end loop;
    TIO.Close(F);

    -- fill Natural -> StringSet Map
    C1 := counter.First;
    while String_Counters.Has_Element(C1) loop
       if sorted_counts.Contains(String_Counters.Element(C1)) then
          tmp_set := sorted_counts.Element(String_Counters.Element(C1));
          tmp_set.Include(String_Counters.Key(C1));
       else
          sorted_counts.Include(String_Counters.Element(C1), String_Sets.To_Set(String_Counters.Key(C1)));
       end if;
       String_Counters.Next(C1);
    end loop;

    -- output
    C2 := sorted_counts.First;
    while Sorted_Counters.Has_Element(C2) loop
       for Item of Sorted_Counters.Element(C2) loop
          Ada.Integer_Text_IO.Put(TIO.Standard_Output, Sorted_Counters.Key(C2), width => 9);
          TIO.Put(TIO.Standard_Output, " ");
          TIO.Put_Line(Item);
       end loop;
       Sorted_Counters.Next(C2);
       how_many := how_many - 1;
       exit when how_many = 0;
    end loop;
end Word_Frequency;
