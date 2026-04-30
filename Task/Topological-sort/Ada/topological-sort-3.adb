private with Ada.Containers.Indefinite_Vectors;

generic
   type Index_Type_With_Null is new Natural;
package Set_Of_Names is
   subtype Index_Type is Index_Type_With_Null
       range 1 .. Index_Type_With_Null'Last;
   -- manage a set of strings;
   -- each string in the set is assigned a unique index of type Index_Type

   type Set is tagged private;

   -- inserts Name into Names; do nothing if already there;
   procedure Add(Names: in out Set; Name: String);

   -- Same operation, additionally emiting Index=Names.Idx(Name)
   procedure Add(Names: in out Set; Name: String; Index: out Index_Type);

   -- remove Name from Names; do nothing if not found
   -- the removal may change the index of other strings in Names
   procedure Sub(Names: in out Set; Name: String);

   -- returns the unique index of Name in Set; or 0 if Name is not there
   function Idx(Names: Set; Name: String) return Index_Type_With_Null;

   -- returns the unique name of Index;
   function Name(Names: Set; Index: Index_Type) return String;

   -- first index, last index and total number of names in set
   -- to iterate over Names, use "for I in Names.Start .. Names.Stop loop ...
   function Start(Names: Set) return Index_Type;
   function Stop(Names: Set) return Index_Type_With_Null;
   function Size(Names: Set) return Index_Type_With_Null;

private

   package Vecs is new Ada.Containers.Indefinite_Vectors
     (Index_Type => Index_Type, Element_Type => String);

   type Set is new Vecs.Vector with null record;

end Set_Of_Names;
