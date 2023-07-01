Program IntegerSequenceUnlimited;

uses
  gmp;

var
  Number: mpz_t;

begin
  mpz_init(Number); //* zero now *//
  repeat
    mp_printf('%Zd' + chr(13) + chr(10), @Number);
    mpz_add_ui(Number, Number, 1); //* increase Number *//
  until false;
end.
