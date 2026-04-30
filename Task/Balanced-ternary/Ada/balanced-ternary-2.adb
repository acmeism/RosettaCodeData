with Ada.Unchecked_Deallocation;

package body BT is

   procedure Free is new Ada.Unchecked_Deallocation (Trit_Array, Trit_Access);

   -- Conversions
   -- String to BT
   function To_Balanced_Ternary (Str: String) return Balanced_Ternary is
      J : Positive := 1;
      Tmp : Trit_Access;
   begin
      Tmp := new Trit_Array (1..Str'Last);
      for I in reverse Str'Range loop
	 case Str(I) is
	    when '+' => Tmp (J) := 1;
	    when '-' => Tmp (J) := -1;
	    when '0' => Tmp (J) := 0;
	    when others => raise Constraint_Error;
	 end case;
	 J := J + 1;
      end loop;
      return (Ada.Finalization.Controlled with Ref => Tmp);
   end To_Balanced_Ternary;

   -- Integer to BT
   function To_Balanced_Ternary (Num: Integer) return Balanced_Ternary is
      K      : Integer := 0;
      D      : Integer;
      Value  : Integer := Num;
      Tmp    : Trit_Array(1..19); -- 19 trits is enough to contain
                                   -- a 32 bits signed integer
   begin
      loop
	 D := (Value mod 3**(K+1))/3**K;
	 if D = 2 then D := -1; end if;
	 Value := Value - D*3**K;
	 K := K + 1;
	 Tmp(K) := Trit(D);
	 exit when Value = 0;
      end loop;
      return (Ada.Finalization.Controlled
		with Ref => new Trit_Array'(Tmp(1..K)));
   end To_Balanced_Ternary;

   -- BT to Integer --
   -- If the BT number is too large Ada will raise CONSTRAINT ERROR
   function To_Integer (Num : Balanced_Ternary) return Integer is
      Value : Integer := 0;
      Pos : Integer := 1;
   begin
      for I in Num.Ref.all'Range loop
	 Value := Value + Integer(Num.Ref(I)) * Pos;
	 Pos := Pos * 3;
      end loop;
      return Value;
   end To_Integer;

   -- BT to String --
   function To_String (Num : Balanced_Ternary) return String is
      I : constant Integer := Num.Ref.all'Last;
      Result : String (1..I);
   begin
      for J in Result'Range loop
	 case Num.Ref(I-J+1) is
	    when 0  => Result(J) := '0';
	    when -1 => Result(J) := '-';
	    when 1  => Result(J) := '+';
	 end case;
      end loop;
      return Result;
   end To_String;

   -- unary minus --
   function "-" (Left : in Balanced_Ternary)
		return Balanced_Ternary is
      Result : constant Balanced_Ternary := Left;
   begin
      for I in Result.Ref.all'Range loop
	 Result.Ref(I) := - Result.Ref(I);
      end loop;
      return Result;
   end "-";

   -- addition --
   Carry : Trit;

   function Add (Left, Right : in Trit)
		return Trit is
   begin
      if Left /= Right then
	 Carry := 0;
	 return Left + Right;
      else
	 Carry := Left;
	 return -Right;
      end if;
   end Add;
   pragma Inline (Add);

   function "+" (Left, Right : in Trit_Array)
		return Balanced_Ternary is
      Max_Size : constant Integer :=
	Integer'Max(Left'Last, Right'Last);
      Tmp_Left, Tmp_Right : Trit_Array(1..Max_Size) := (others => 0);
      Result : Trit_Array(1..Max_Size+1) := (others => 0);
   begin
      Tmp_Left (1..Left'Last) := Left;
      Tmp_Right(1..Right'Last) := Right;
      for I in Tmp_Left'Range loop
	 Result(I) := Add (Result(I), Tmp_Left(I));
	 Result(I+1) := Carry;
	 Result(I) := Add(Result(I), Tmp_Right(I));
	 Result(I+1) := Add(Result(I+1), Carry);
      end loop;
      -- remove trailing zeros
      for I in reverse Result'Range loop
	 if Result(I) /= 0 then
	    return (Ada.Finalization.Controlled
		      with Ref => new Trit_Array'(Result(1..I)));
	 end if;
      end loop;
      return (Ada.Finalization.Controlled
		with Ref => new Trit_Array'(1 => 0));
   end "+";

   function "+" (Left, Right : in Balanced_Ternary)
		return Balanced_Ternary is
   begin
      return Left.Ref.all + Right.Ref.all;
   end "+";

   -- Subtraction
   function "-" (Left, Right : in Balanced_Ternary)
		return Balanced_Ternary is
   begin
      return Left + (-Right);
   end "-";

   -- multiplication
   function "*" (Left, Right : in Balanced_Ternary)
		return Balanced_Ternary is
      A, B : Trit_Access;
      Result : Balanced_Ternary;
   begin
      if Left.Ref.all'Length > Right.Ref.all'Length then
	 A := Right.Ref; B := Left.Ref;
      else
	 B := Right.Ref; A := Left.Ref;
      end if;
      for I in A.all'Range loop
	 if A(I) /= 0 then
	    declare
	       Tmp_Result : Trit_Array (1..I+B.all'Length-1) := (others => 0);
	    begin
	       for J in B.all'Range loop
		  Tmp_Result(I+J-1) := B(J) * A(I);
	       end loop;
	       Result := Result.Ref.all + Tmp_Result;
	    end;
	 end if;
      end loop;
      return Result;
   end "*";

   procedure Adjust (Object : in out Balanced_Ternary) is
   begin
      Object.Ref := new Trit_Array'(Object.Ref.all);
   end Adjust;

   procedure Finalize  (Object : in out Balanced_Ternary) is
   begin
      Free (Object.Ref);
   end Finalize;

   procedure Initialize (Object : in out Balanced_Ternary) is
   begin
      Object.Ref := new Trit_Array'(1 => 0);
   end Initialize;

end BT;
