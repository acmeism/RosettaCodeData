with Ada.Text_IO;
with Ada.Containers.Generic_Array_Sort;

procedure EKG_Sequences is

   type Element_Type is new Integer;

   type    Index_Type is new Integer range 1 .. 100;
   subtype Show_Range is Index_Type  range 1 .. 30;

   type Sequence is array (Index_Type range <>) of Element_Type;
   subtype EKG_Sequence is Sequence (Index_Type);

   function GCD (Left, Right : Element_Type) return Integer is
      A : Element_Type := Left;
      B : Element_Type := Right;
   begin
      while A /= B loop
         if A > B
         then A := A - B;
         else B := B - A;
         end if;
      end loop;
      return Integer (A);
   end GCD;

   function Contains (A    : Sequence;
                      B    : Element_Type;
                      Last : Index_Type) return Boolean
   is (for some Value of A (A'First .. Last) =>  Value = B);

   function Are_Same (S, T : EKG_Sequence; Last : Index_Type) return Boolean is
      S_Copy : Sequence := S (S'First .. Last);
      T_Copy : Sequence := T (T'First .. Last);
      procedure Sort is
        new Ada.Containers.Generic_Array_Sort (Index_Type   => Index_Type,
                                               Element_Type => Element_Type,
                                               Array_Type   => Sequence);
   begin
      Sort (S_Copy);
      Sort (T_Copy);
      return S_Copy = T_Copy;
   end Are_Same;

   function Create_EKG (Start : Element_Type) return EKG_Sequence is
      EKG : EKG_Sequence := (1 => 1, 2 => Start, others => 0);
   begin
      for N in 3 .. Index_Type'Last loop
         for I in 2 .. Element_Type'Last loop
            --  A potential sequence member cannot already have been used
            --  and must have a factor in common with previous member
            if not Contains (EKG, I, N)
              and then GCD (EKG (N - 1), I) > 1
            then
               EKG (N) := I;
               exit;
            end if;
         end loop;
      end loop;
      return EKG;
   end Create_EKG;

   procedure Converge (Seq_A, Seq_B : Sequence;
                       Term         : out Index_Type;
                       Do_Converge  : out Boolean) is
   begin
      for I in 3 .. Index_Type'Last loop
         if Seq_A (I) = Seq_B (I) and then Are_Same (Seq_A, Seq_B, I) then
            Do_Converge := True;
            Term        := I;
            return;
         end if;
      end loop;
      Do_Converge := False;
      Term        := Index_Type'Last;
   end Converge;

   procedure Put (Seq : Sequence) is
      use Ada.Text_IO;
   begin
      Put ("[");
      for E of Seq (Show_Range) loop
         Put (E'Image);
      end loop;
      Put ("]");
   end Put;

   use Ada.Text_IO;
   EKG_2  : constant EKG_Sequence := Create_EKG (2);
   EKG_5  : constant EKG_Sequence := Create_EKG (5);
   EKG_7  : constant EKG_Sequence := Create_EKG (7);
   EKG_9  : constant EKG_Sequence := Create_EKG (9);
   EKG_10 : constant EKG_Sequence := Create_EKG (10);
begin
   Put ("EKG( 2): ");  Put (EKG_2);  New_Line;
   Put ("EKG( 5): ");  Put (EKG_5);  New_Line;
   Put ("EKG( 7): ");  Put (EKG_7);  New_Line;
   Put ("EKG( 9): ");  Put (EKG_9);  New_Line;
   Put ("EKG(10): ");  Put (EKG_10); New_Line;

   --  Now compare EKG5 and EKG7 for convergence
   declare
      Term        : Index_Type;
      Do_Converge : Boolean;
   begin
      Converge (EKG_5, EKG_7, Term, Do_Converge);
      New_Line;
      if Do_Converge then
         Put_Line ("EKG(5) and EKG(7) converge at term "
                     & Term'Image);
      else
         Put_Line ("EKG5(5) and EKG(7) do not converge within "
                     & Term'Image & " terms");
      end if;
   end;
end EKG_Sequences;
