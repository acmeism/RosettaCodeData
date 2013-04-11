with Ada.Text_IO, Logic;

procedure Twelve_Statements is

   package L is new Logic(Number_Of_Statements => 12); use L;

   -- formally define the 12 statements as expression function predicates
   function P01(T: Table) return Boolean is (T'Length = 12);              -- list of 12 statements
   function P02(T: Table) return Boolean is (Sum(T(7 .. 12)) = 3);        -- three of last six
   function P03(T: Table) return Boolean is (Sum(Half(T, Even)) = 2);     -- two of the even
   function P04(T: Table) return Boolean is (if T(5) then T(6) and T(7)); -- if 5 is true, then ...
   function P05(T: Table) return Boolean is
      ( (not T(2)) and (not T(3)) and (not T(4)) );                       -- none of preceding three
   function P06(T: Table) return Boolean is (Sum(Half(T, Odd)) = 4);      -- four of the odd
   function P07(T: Table) return Boolean is (T(2) xor T(3));              -- either 2 or 3, not both
   function P08(T: Table) return Boolean is (if T(7) then T(5) and T(6)); -- if 7 is true, then ...
   function P09(T: Table) return Boolean is (Sum(T(1 .. 6)) = 3);         -- three of first six
   function P10(T: Table) return Boolean is (T(11) and T(12));            -- next two
   function P11(T: Table) return Boolean is (Sum(T(7..9)) = 1);           -- one of 7, 8, 9
   function P12(T: Table) return Boolean is (Sum(T(1 .. 11)) = 4);        -- four of the preding

   -- define a global list of statements
   Statement_List: constant Statements :=
     (P01'Access, P02'Access, P03'Access, P04'Access, P05'Access, P06'Access,
      P07'Access, P08'Access, P09'Access, P10'Access, P11'Access, P12'Access);

   -- try out all 2^12 possible choices for the table
   procedure Try(T: Table; Fail: Natural; Idx: Indices'Base := Indices'First) is

      procedure Print_Table(T: Table) is
	 use Ada.Text_IO;
      begin
	 Put("    ");
	 if Fail > 0 then
	    Put("(wrong at");
	    for J in T'Range loop
	       if Statement_List(J)(T) /= T(J) then
		  Put(Integer'Image(J) & (if J < 10 then ")  " else ") "));
	       end if;
	    end loop;
	 end if;
	 if T = (1..12 => False) then
	    Put_Line("All false!");
	 else
	    Put("True are");
	    for J in T'Range loop
	       if T(J) then
		  Put(Integer'Image(J));
	       end if;
	    end loop;
	    New_Line;
	 end if;
      end Print_Table;

      Wrong_Entries: Natural := 0;
	
   begin
      if Idx <= T'Last then
	 Try(T(T'First .. Idx-1) & False & T(Idx+1 .. T'Last), Fail, Idx+1);
	 Try(T(T'First .. Idx-1) & True  & T(Idx+1 .. T'Last), Fail, Idx+1);
      else -- now Index > T'Last and we have one of the 2^12 choices to test
	 for J in T'Range loop 	
	    if Statement_List(J)(T) /= T(J) then
	       Wrong_Entries := Wrong_Entries + 1;
	    end if;
	 end loop;
	 if Wrong_Entries = Fail then
	    Print_Table(T);
	 end if;
      end if;
   end Try;
			
begin
   Ada.Text_IO.Put_Line("Exact hits:");
   Try(T => (1..12 => False), Fail => 0);
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line("Near Misses:");
   Try(T => (1..12 => False), Fail => 1);
end Twelve_Statements;
