with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;

procedure Search_A_List_Of_Records
is
   function "+"(input : in String) return Unbounded_String renames To_Unbounded_String;
   function "+"(input : in Unbounded_String) return String renames To_String;

   type City is record
      name : Unbounded_String;
      population : Float;
   end record;

   type City_Array is array(Positive range <>) of City;
   type City_Array_Access is access City_Array;

   type Cursor is record
      container : City_Array_Access;
      index : Natural;
   end record;

   function Element(C : in Cursor) return City is
   begin
      if C.container = null or C.index = 0 then
         raise Constraint_Error with "No element.";
      end if;

      return C.container.all(C.index);
   end Element;

   function Index_0(C : in Cursor) return Natural is
   begin
      if C.container = null or C.index = 0 then
         raise Constraint_Error with "No element.";
      end if;

      return C.index - C.container.all'First;
   end Index_0;

   function Find
     (container : in City_Array;
      check : not null access function(Element : in City) return Boolean)
      return Cursor
   is
   begin
      for I in container'Range loop
         if check.all(container(I)) then
            return (new City_Array'(container), I);
         end if;
      end loop;
      return (null, 0);
   end;

   function Dar_Es_Salaam(Element : in City) return Boolean is
   begin
      return Element.name = "Dar Es Salaam";
   end Dar_Es_Salaam;

   function Less_Than_Five_Million(Element : in City) return Boolean is
   begin
      return Element.population < 5.0;
   end Less_Than_Five_Million;

   function Starts_With_A(Item : in City) return Boolean is
   begin
      return Element(Item.name, 1) = 'A';
   end Starts_With_A;

   cities : constant City_Array :=
     ((+"Lagos",                21.0),
      (+"Cairo",                15.2),
      (+"Kinshasa-Brazzaville", 11.3),
      (+"Greater Johannesburg", 7.55),
      (+"Mogadishu",            5.85),
      (+"Khartoum-Omdurman",    4.98),
      (+"Dar Es Salaam",        4.7 ),
      (+"Alexandria",           4.58),
      (+"Abidjan",              4.4 ),
      (+"Casablanca",           3.98));
begin
   Ada.Text_IO.Put_Line(Index_0(Find(cities, Dar_Es_Salaam'Access))'Img);
   Ada.Text_IO.Put_Line(+Element(Find(cities, Less_Than_Five_Million'Access)).name);
   Ada.Text_IO.Put_Line(Element(Find(cities, Starts_With_A'Access)).population'Img);
end Search_A_List_Of_Records;
