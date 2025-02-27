with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;

procedure Arithmetic_Derivative is

	function D (N : Big_Integer) return Big_Integer is
		Inc : Constant array (1 .. 8) of Big_Integer := (4, 2, 4, 2, 4, 6, 2, 6);
		I : Integer := 1;
		Num : Big_Integer := N;
		P : Big_Integer := 2;
		PCount : Big_Integer;
		Result : Big_Integer := 0;
	begin
		if N < 0 then return -D(-N); end if;
		if N = 0 or N = 1 then return 0; end if;

		while P <= N / 2 loop
			if Num mod P = 0 then
				PCount := 0;
				while Num mod P = 0 loop
					Num := Num / P;
					PCount := PCount + 1;
				end loop;
				Result := Result + (PCount * N) / P;
			end if;
			if Num = 1 then exit; end if;
			if P >= 7 then
				P := P + Inc(I);
				I := (I mod 8) + 1;
			end if;
			if P = 3 or P = 5 then P := P + 2; end if;
			if P = 2 then P := P + 1; end if;
		end loop;
		
		if Num > 1 then return 1; end if;

		return result;
	end D;

	P : Big_Integer;

begin
	for I in Integer range -99 .. 100 loop
		P := To_Big_Integer(I);
		Put(To_String(Arg => D(P), Width => 5));
		if I mod 10 = 0 then New_Line; end if;
	end loop;

	for I in Integer range 1 .. 20 loop
		P := 10 ** I;
		Put("D(10^"); Put(Item => I, Width => 2); Put(") / 7 = ");
		Put(Big_Integer'Image(D(P) / 7)); New_Line;
	end loop;
end Arithmetic_Derivative;
