package body Markov is

   function Parse (S : String_Array) return Ruleset is
      Result : Ruleset (Length => S'Length);
   begin
      for I in S'Range loop
         if Length (S (I)) = 0 or else Element (S (I), 1) = '#' then
            Result.Entries (I) := (Kind => Comment, Text => S (I));
         else
            declare
               Separator   : Natural;
               Terminating : Boolean;
               Target      : Unbounded_String;
            begin
               Separator := Index (S (I), " -> ");
               if Separator = 0 then
                  raise Constraint_Error;
               end if;
               Target      :=
                  Unbounded_Slice
                    (Source => S (I),
                     Low    => Separator + 4,
                     High   => Length (S (I)));
               Terminating := Length (Target) > 0
                             and then Element (Target, 1) = '.';
               if Terminating then
                  Delete (Source => Target, From => 1, Through => 1);
               end if;
               Result.Entries (I) :=
                 (Kind           => Rule,
                  Source         => Unbounded_Slice
                                      (Source => S (I),
                                       Low    => 1,
                                       High   => Separator - 1),
                  Target         => Target,
                  Is_Terminating => Terminating);
            end;
         end if;
      end loop;
      return Result;
   end Parse;

   procedure Apply
     (R        : Rule_Entry;
      S        : in out Unbounded_String;
      Modified : in out Boolean)
   is
      Pattern : String  := To_String (R.Source);
      Where   : Natural := Index (S, Pattern);
   begin
      while Where /= 0 loop
         Modified := True;
         Replace_Slice
           (Source => S,
            Low    => Where,
            High   => Where + Pattern'Length - 1,
            By     => To_String (R.Target));
         Where := Index (S, Pattern, Where + Length (R.Target));
      end loop;
   end Apply;

   function Apply (R : Ruleset; S : String) return String is
      Result       : Unbounded_String := To_Unbounded_String (S);
      Current_Rule : Set_Entry;
      Modified     : Boolean          := False;
   begin
      loop
         Modified := False;
         for I in R.Entries'Range loop
            Current_Rule := R.Entries (I);
            if Current_Rule.Kind = Rule then
               Apply (Current_Rule, Result, Modified);
               exit when Current_Rule.Is_Terminating or else Modified;
            end if;
         end loop;
         exit when not Modified;
      end loop;
      return To_String (Result);
   end Apply;

end Markov;
