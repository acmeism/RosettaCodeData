with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure De_Polignac is

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

	function Is_De_Polignac (N: Integer) return Boolean is
		I : Integer := 1;
	begin
		while I < N loop
			if Is_Prime(N-I) then return False; end if;
			I := I * 2;
		end loop;

		return True;
	end Is_De_Polignac;
	
	Count : Integer := 1;
	N : Integer := 1;

begin
	Put("The first 50 de Polignac numbers are: "); New_Line;
	while Count <= 10_000 loop
		If Is_De_Polignac(N) then
			If Count <= 50 then
				Put(Item => N, Width => 5);
				if Count mod 10 = 0 then New_Line; end if;
			end if;
			if Count = 1_000 then
				New_Line;
				Put("The 1000th de Polignac number is: ");
				Put(Item => N, Width => 7); New_Line;
			end if;
			if Count = 10_000 then
				Put("The 10000th de Polignac number is: ");
				Put(Item => N, Width => 6);
			end if;
			Count := Count + 1;
		end if;
		N := N + 2;
	end loop;
end De_Polignac;
