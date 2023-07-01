var IS32: integer;	{Signed 32-bit integer}
var IS64: Int64;	{Signed 64-bit integer}
var IU32: cardinal;	{Unsigned 32-bit integer}

{============ Signed 32 bit tests ===================================}

procedure TestSigned32_1;
begin
IS32:=-(-2147483647-1);
end;

// Compiler: "Overflow in conversion or arithmetic operation"

procedure TestSigned32_2;
begin
IS32:=2000000000 + 2000000000;
end;

// Compiler: "Overflow in conversion or arithmetic operation"



procedure TestSigned32_3;
begin
IS32:=-2147483647 - 2147483647;
end;

// Compiler: "Overflow in conversion or arithmetic operation"

procedure TestSigned32_4;
begin
IS32:=46341 * 46341;
end;

// Compiler: "Overflow in conversion or arithmetic operation"



procedure TestSigned32_5;
begin
IS32:=(-2147483647-1) div -1;
end;

// Compiler: "Overflow in conversion or arithmetic operation"

{============ Signed 64 bit tests ===================================}

procedure TestSigned64_1;
begin
IS64:=-(-9223372036854775807-1);
end;

// Compiler: "Overflow in conversion or arithmetic operation"


procedure TestSigned64_2;
begin
IS64:=5000000000000000000+5000000000000000000;
end;

// Compiler: "Overflow in conversion or arithmetic operation"


procedure TestSigned64_3;
begin
IS64:=-9223372036854775807 - 9223372036854775807;
end;

// Compiler: "Overflow in conversion or arithmetic operation"


procedure TestSigned64_4;
begin
IS64:=3037000500 * 3037000500;
end;

// Compiler: "Overflow in conversion or arithmetic operation"


procedure TestSigned64_5;
begin
IS64:=(-9223372036854775807-1) div -1;
end;

// Compiler: "Overflow in conversion or arithmetic operation"


{============ UnSigned 32 bit tests ===================================}

procedure TestUnSigned32_1;
begin
IU32:=-4294967295;
end;

// Compiler: "Overflow in conversion or arithmetic operation"


procedure TestUnSigned32_2;
begin
IU32:=3000000000 + 3000000000;
end;

// Compiler: "Overflow in conversion or arithmetic operation"


procedure TestUnSigned32_3;
begin
IU32:=2147483647 - 4294967295;
end;

// Compiler: "Overflow in conversion or arithmetic operation"


procedure TestUnSigned32_4;
begin
IU32:=65537 * 65537;
end;

// Compiler: "Overflow in conversion or arithmetic operation"


//Delphi-6 does not have 64-bit unsigned integers.
//Later version have 64-bit unsigned integers.
