with Ada.Containers.Indefinite_Vectors;

package String_Helper is

   function Index(Source: String; Pattern: String) return Natural;

   procedure Search_Brackets(Source: String;
                             Left_Bracket: String;
                             Right_Bracket: String;
                             First, Last: out Natural);
      -- returns indices of first pair of brackets in source
      -- indices are zero if no such brackets are found

   function Replace(Source: String; Old_Word: String; New_Word: String)
                   return String;

   package String_Vec is new Ada.Containers.Indefinite_Vectors
     (Index_Type   => Positive,
      Element_Type => String);

   type Vector is new String_Vec.Vector with null record;

   function Get_Vector(Filename: String) return Vector;

end String_Helper;
