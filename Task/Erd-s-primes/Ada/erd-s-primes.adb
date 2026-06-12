with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Erdos is

	Limit : constant := 1000000;
	Lower_Limit : constant := 2500;
	type Bool_Array is array (Natural range <>) of Boolean;

	function Sieve (L : Integer) return Bool_Array is
		I : Integer := 4;
		P, P2 : Integer;
		C : Bool_Array (0 .. L) := (others => False);
	begin
		C(0) := True;
		C(1) := True;

		while I <= L loop
			C(I) := True;
			I := I + 2;
		end loop;

		P := 3;
		loop
			P2 := P * P;
			exit when P2 > L;
			I := P2;
			while I <= L loop
				C(I) := True;
				I := I + (P * 2);
			end loop;

			loop
				P := P + 2;
				exit when P > L or else not C(P);
			end loop;
		end loop;

		return C;
	end Sieve;

	C : constant Bool_Array (0 .. Limit - 1) := Sieve(Limit - 1);
	Found : Boolean;
	Erdos : Array (1 .. 31) of Integer;
	I, J, Fact, Last_Erdos: Integer;
	EC, EC2 : Integer := 0;

begin
	I := 2;
	while I < Limit loop
		if  not C(I) then
			J := 1;
			Fact := 1;
			Found := True;
			while Fact < I loop
				if not C(I - Fact) then
					Found := False;
					exit;
				end if;
				J := J + 1;
				Fact := Fact * J;
			end loop;
			if Found then
				if I < Lower_Limit then
					EC2 := EC2 + 1;
					Erdos(EC2) := I;
				end if;
				Last_Erdos := I;
				EC := EC + 1;
			end if;
		end if;
		if I > 2 then
			I := I + 2;
		else
			I := I + 1;
		end if;
	end loop;
	Put("The "); Put(Item => EC2, Width => 2); Put(" Erdős primes under ");
	Put(Item => Lower_Limit, Width => 4); Put(" are:"); New_Line;
	I := 1;
	while I <= EC2 loop
		Put(Item => Erdos(I), Width => 6);
		if I mod 10 = 0 then
			New_Line;
		end if;
		I := I + 1;
	end loop;
	New_Line; New_Line;
	Put("The "); Put(Item => EC, Width => 4); Put("th Erdős prime is ");
	Put(Item => Last_Erdos, Width => 6); Put(".");
end Erdos;
