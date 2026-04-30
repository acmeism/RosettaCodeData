with Ada.Containers.Indefinite_Ordered_Sets;
with Ada.Finalization;
with Ada.Text_IO; use Ada.Text_IO;
procedure Heronian is
   package Int_IO is new Ada.Text_IO.Integer_IO(Integer);
   use Int_IO;

   -- ----- Some math...
   function GCD (A, B : in Natural) return Natural is (if B = 0 then A else GCD (B, A mod B));

   function Int_Sqrt (N : in Natural) return Natural is
      R1 : Natural := N;
      R2 : Natural;
   begin
      if N <= 1 then
         return N;
      end if;
      loop
         R2 := (R1+N/R1)/2;
         if R2 >= R1 then
            return R1;
         end if;
         R1 := R2;
      end loop;
   end Int_Sqrt;

   -- ----- Defines the triangle with sides as discriminants and a constructor which will
   -- compute its other characteristics
   type t_Triangle (A, B, C : Positive) is new Ada.Finalization.Controlled with record
      Is_Heronian  : Boolean;
      Perimeter    : Positive;
      Area         : Natural;
   end record;

   overriding procedure Initialize (Self : in out t_Triangle) is
      -- Let's stick to integer computations, therefore a modified hero's formula
      -- will be used : S*(S-a)*(S-b)*(S-c) = (a+b+c)*(-a+b+c)*(a-b+c)*(a+b-c)/16
      -- This will require long integers because at max side size, the product
      -- before /16 excesses 2^31
      Long_Product  : Long_Long_Integer;
      Short_Product : Natural;
   begin
      Self.Perimeter   := Self.A + Self.B + Self.C;
      Long_Product     :=   Long_Long_Integer(Self.Perimeter)
                          * Long_Long_Integer(- Self.A + Self.B + Self.C)
                          * Long_Long_Integer(  Self.A - Self.B + Self.C)
                          * Long_Long_Integer(  Self.A + Self.B - Self.C);
      Short_Product    := Natural(Long_Product / 16);
      Self.Area        := Int_Sqrt (Short_Product);
      Self.Is_Heronian := (Long_Product mod 16 = 0) and (Self.Area * Self.Area = Short_Product);
   end Initialize;

   -- ----- Ordering triangles with criteria (Area,Perimeter,A,B,C)
   function "<" (Left, Right : in t_Triangle) return Boolean is
     (Left.Area      < Right.Area      or else (Left.Area      = Right.Area      and then
     (Left.Perimeter < Right.Perimeter or else (Left.Perimeter = Right.Perimeter and then
     (Left.A         < Right.A         or else (Left.A         = Right.A         and then
     (Left.B         < Right.B         or else (Left.B         = Right.B         and then
      Left.C         < Right.C))))))));
   package Triangle_Lists is new Ada.Containers.Indefinite_Ordered_Sets (t_Triangle);
   use Triangle_Lists;

   -- ----- Displaying triangle characteristics
   Header : constant String := "  A   B   C Per  Area" & ASCII.LF & "---+---+---+---+-----";
   procedure Put_Triangle (Position : Cursor) is
      Triangle : constant t_Triangle := Element(Position);
   begin
      Put(Triangle.A, 3);
      Put(Triangle.B, 4);
      Put(Triangle.C, 4);
      Put(Triangle.Perimeter, 4);
      Put(Triangle.Area,      6);
      New_Line;
   end Put_Triangle;

   -- ----- Global variables
   Triangles : Set := Empty_Set;
   -- Instead of constructing two sets, or browsing all the beginning of the set during
   -- the second output, start/end cursors will be updated during the insertions.
   First_201 : Cursor := No_Element;
   Last_201  : Cursor := No_Element;

   procedure Memorize_Triangle (A, B, C : in Positive) is
      Candidate : t_Triangle(A, B, C);
      Position  : Cursor;
      Dummy     : Boolean;
   begin
      if Candidate.Is_Heronian then
         Triangles.Insert (Candidate, Position, Dummy);
         if Candidate.Area = 210 then
            First_201 := (if    First_201 = No_Element then Position
                          elsif Position < First_201   then Position
                          else  First_201);
            Last_201 :=  (if    Last_201  = No_Element then Position
                          elsif Last_201  < Position   then Position
                          else  Last_201);
         end if;
      end if;
   end Memorize_Triangle;

begin
   -- Loops restrict to unique A,B,C (ensured by A <= B <= C) with sides < 200 and for
   -- which a triangle is constructible : C is not greater than B+A (flat triangle)
   for A in 1..200 loop
      for B in A..200 loop
         for C in B..Integer'Min(A+B-1,200) loop
            -- Filter non-primitive triangles
            if GCD(GCD(A,B),C) = 1 then
               Memorize_Triangle (A, B, C);
            end if;
         end loop;
      end loop;
   end loop;

   Put_Line (Triangles.Length'Img & " heronian triangles found :");
   Put_Line (Header);
   Triangles.Iterate (Process => Put_Triangle'Access);
   New_Line;

   Put_Line ("Heronian triangles with area = 201");
   Put_Line (Header);
   declare
      Position : Cursor := First_201;
   begin
      loop
         Put_Triangle (Position);
         exit when Position = Last_201;
         Position := Next(Position);
      end loop;
   end;
end Heronian;
