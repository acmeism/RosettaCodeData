with Ada.Text_IO; use Ada.Text_IO;
with Ada.Long_Long_Integer_Text_IO; use Ada.Long_Long_Integer_Text_IO;

procedure Curzon is

	function Mod_Pow(Base, Exp, Modulo : Long_Long_Integer) return Long_Long_Integer is
		Result : Long_Long_Integer := 1;
		B : Long_Long_Integer := Base mod Modulo;
		E : Long_Long_Integer := Exp;
	begin
		if Modulo = 1 then return 0; end if;

		while E > 0 loop
			if (E mod 2) = 1 then
				Result := (Result * B) mod Modulo;
			end if;
			B := (B * B) mod Modulo;
			E := E / 2;
		end loop;

		return Result;
	end Mod_Pow;

	function Curzon_Check(K, N : Long_Long_Integer) return Boolean is
		R : Long_Long_Integer := K * N;
	begin
		return Mod_Pow(K, N, R + 1) = R;
	end Curzon_Check;

	N : Long_Long_Integer;
	Count : Integer;

begin
	for K in Long_Long_Integer range 2..10 when K mod 2 = 0 loop
		Put("The first 50 Curzon numbers of base "); Put(K, 1); Put(":"); New_Line;
		N := 1;
		Count := 1;
		while Count <= 1000 loop
			if Curzon_Check(K, N) then
				if Count <= 50 then
					Put(N, 4);
					if Count mod 10 = 0 then
						New_Line;
					else
						Put(" ");
					end if;
				end if;
				if Count = 1000 then
					Put("The 1000th Curzon number of base "); Put(K, 1); Put(": "); Put(N, 5);
					New_Line(2);
				end if;
				Count := @ + 1;
			end if;
			N := @ + 1;
		end loop;
	end loop;
end Curzon;
