program GMPfact;

{$mode objfpc}

uses

    gmp
    ;

    function Factorial(n: qword): string;
        var
            ResultMPZ: mpz_t;
            i: qword;
        begin
            mpz_init_set_ui(ResultMPZ, 1);
            for i := 2 to n do
                mpz_mul_ui(ResultMPZ, ResultMPZ, i);
            Result := mpz_get_str(nil, 10, ResultMPZ);
            mpz_clear(ResultMPZ);
        end;

var
    N     : integer = 101 ;
    Fact  :        string ;

begin
    Fact := Factorial(101);
    writeln( N ,'! = ', Fact);
end.    (*)     GMPfact     (*)


Output:
101! = 9425947759838359420851623124482936749562312794702543768327889353416977599316221476503087861591808346911623490003549599583369706302603264000000000000000000000000
