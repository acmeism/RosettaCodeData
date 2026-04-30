with Ada.Containers.Indefinite_Vectors, Ada.Text_IO;

package String_Vectors is

   package String_Vec is new Ada.Containers.Indefinite_Vectors
     (Index_Type => Positive, Element_Type => String);

   type Vec is new String_Vec.Vector with null record;

   function Read(Filename: String) return Vec;
     -- uses Ada.Text_IO to read words from the given file into a Vec
     -- requirement: each word is written in a single line

   function Is_In(List: Vec;
                  Word: String;
                  Start: Positive; Stop: Natural) return Boolean;
     -- checks if Word is in List(Start .. Stop);
     -- requirement: the words in List are sorted alphabetically
end String_Vectors;
