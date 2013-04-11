with Ada.Strings.Unbounded;
private with Ada.Containers.Indefinite_Vectors;

generic
   with procedure Print_Line(Indention: Natural; Line: String);
package S_Expr is

   function "-"(S: String) return Ada.Strings.Unbounded.Unbounded_String
     renames Ada.Strings.Unbounded.To_Unbounded_String;

   function "+"(U: Ada.Strings.Unbounded.Unbounded_String) return String
     renames Ada.Strings.Unbounded.To_String;

   type Empty_Data is tagged null record;
   subtype Data is Empty_Data'Class;
   procedure Print(This: Empty_Data; Indention: Natural);
   -- any object form class Data knows how to print itself
   -- objects of class data are either List of Data or Atomic
   -- atomic objects hold either an integer or a float or a string

   type List_Of_Data is new Empty_Data with private;
   overriding procedure Print(This: List_Of_Data; Indention: Natural);
   function First(This: List_Of_Data) return Data;
   function Rest(This: List_Of_Data) return List_Of_Data;
   function Empty(This: List_Of_Data) return Boolean;

   type Atomic is new Empty_Data with null record;

   type Str_Data is new Atomic with record
      Value: Ada.Strings.Unbounded.Unbounded_String;
      Quoted: Boolean := False;
   end record;
   overriding procedure Print(This: Str_Data; Indention: Natural);

   type Int_Data is new Atomic with record
      Value: Integer;
   end record;
   overriding procedure Print(This: Int_Data; Indention: Natural);

   type Flt_Data is new Atomic with record
      Value: Float;
   end record;
   overriding procedure Print(This: Flt_Data; Indention: Natural);

private

   package Vectors is new Ada.Containers.Indefinite_Vectors
     (Index_Type   => Positive,
      Element_Type => Data);

   type List_Of_Data is new Empty_Data with record
      Values: Vectors.Vector;
   end record;

end S_Expr;
