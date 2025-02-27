with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

procedure Blum is

   Inc : Constant array (1 .. 8) of Integer := (4, 2, 4, 2, 4, 6, 2, 6);

   function Is_Prime (N : Integer) return Boolean is
      D : Integer := 5;
   begin
      if N < 2 then return False; end if;
      if N mod 2 = 0 then return N = 2; end if;
      if N mod 3 = 0 then return N = 3; end if;

      while D * D <= N loop
         if N mod D = 0 then return False; end if;
	     D := D + 2;
	     if N mod D = 0 then return False; end if;
	     D := D + 4;
      end loop;

      return True;
   end Is_Prime;

   function First_Prime_Factor (N : Integer) return Integer is
      D : Integer := 7;
      I : Integer := 1;
   begin
      if N = 1 then return 1; end if;
      if N mod 3 = 0 then return 3; end if;
      if N mod 5 = 0 then return 5; end if;

      while D * D <= N loop
         if N mod D = 0 then
            return D;
	     end if;
	     D := D + Inc(I);
         I := (I mod 8) + 1;
      end loop;

      return N;
   end First_Prime_Factor;

   I, Blum_Count : Integer := 1;
   J, P, Q : Integer;
   Blums : Array (1 .. 50) of Integer;
   Counts : Array (1 .. 4) of Integer := (others => 0);
   Final_Digits : Array (1 .. 4) of Integer := (1, 3, 7, 9);

begin
   loop
      P := First_Prime_Factor(I);
      if P mod 4 = 3 then
         Q := I / P;
	     if Q /= P and Q mod 4 = 3 and Is_Prime(Q) then
            if Blum_Count < 51 then Blums(Blum_Count) := I; end if;
	        Counts(((I mod 10) / 3) + 1) := Counts(((I mod 10) / 3) + 1) + 1;
	        Blum_Count := Blum_Count + 1;
	        if Blum_Count = 51 then
               Put("First 50 Blum Integers:"); New_Line;
               for J in Integer range 1 .. 50 loop
                  Put(Item => Blums(J), Width => 3); Put(" ");
	              if J mod 10 = 0 then New_Line; end if;
               end loop;
	           New_Line;
	        elsif Blum_Count = 26829 or Blum_Count mod 100000 = 1 then
	           Put("The "); Put(Item => Blum_Count, Width => 7);
               Put("th Blum Integer is: "); Put(Item => I, Width => 9);
               New_Line;
	           if Blum_Count = 400001 then
		          New_Line; Put("% Distribution of the First 400,000 Blum Integers:"); New_Line;
		          for J in Integer range 1 .. 4 loop
		             Put("  "); Put(Item => Float(Counts(J)) / 4000.0, Fore => 2, Aft => 3, Exp => 0);
                     Put("% end in "); Put(Item => Final_Digits(J), Width => 1);
                     New_Line;
		          end loop;
		          exit;
	           end if;
	        end if;
         end if;
      end if;
      if I mod 5 = 3 then
         I := I + 4;
      else
	     I := I + 2;
      end if;
   end loop;
end Blum;
