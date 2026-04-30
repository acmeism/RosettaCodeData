with Ada.Strings.Unbounded;

package Markov is
   use Ada.Strings.Unbounded;
   type Ruleset (Length : Natural) is private;
   type String_Array is array (Positive range <>) of Unbounded_String;
   function Parse (S : String_Array) return Ruleset;
   function Apply (R : Ruleset; S : String) return String;
private
   type Entry_Kind is (Comment, Rule);
   type Set_Entry (Kind : Entry_Kind := Rule) is record
      case Kind is
         when Rule =>
            Source         : Unbounded_String;
            Target         : Unbounded_String;
            Is_Terminating : Boolean;
         when Comment =>
            Text           : Unbounded_String;
      end case;
   end record;
   subtype Rule_Entry is Set_Entry (Kind => Rule);
   type Entry_Array is array (Positive range <>) of Set_Entry;
   type Ruleset (Length : Natural) is record
      Entries : Entry_Array (1 .. Length);
   end record;
end Markov;
