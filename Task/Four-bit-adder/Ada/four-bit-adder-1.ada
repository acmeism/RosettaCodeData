type Four_Bits is array (1..4) of Boolean;

procedure Half_Adder (Input_1, Input_2 : Boolean; Output, Carry : out Boolean) is
begin
   Output := Input_1 xor Input_2;
   Carry  := Input_1 and Input_2;
end Half_Adder;

procedure Full_Adder (Input_1, Input_2 : Boolean; Output : out Boolean; Carry : in out Boolean) is
   T_1, T_2, T_3 : Boolean;
begin
   Half_Adder (Input_1, Input_2, T_1, T_2);
   Half_Adder (Carry, T_1, Output, T_3);
   Carry := T_2 or T_3;
end Full_Adder;

procedure Four_Bits_Adder (A, B : Four_Bits; C : out Four_Bits; Carry : in out Boolean) is
begin
   Full_Adder (A (4), B (4), C (4), Carry);
   Full_Adder (A (3), B (3), C (3), Carry);
   Full_Adder (A (2), B (2), C (2), Carry);
   Full_Adder (A (1), B (1), C (1), Carry);
end Four_Bits_Adder;
