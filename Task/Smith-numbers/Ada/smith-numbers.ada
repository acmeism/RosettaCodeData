with Ada.Text_IO;

procedure smith is
  type Vector is array (natural range <>) of Positive;
  empty_vector : constant Vector(1..0):= (others=>1);

  function digits_sum (n : Positive) return Positive is
  (if n < 10 then n else n mod 10 + digits_sum (n / 10));

  function prime_factors (n : Positive; d : Positive := 2) return Vector is
  (if n = 1 then empty_vector elsif n mod d = 0 then prime_factors (n / d, d) & d
   else prime_factors (n, d + (if d=2 then 1 else 2)));

  function vector_digits_sum (v : Vector) return Natural is
  (if v'Length = 0 then 0 else digits_sum (v(v'First)) + vector_digits_sum (v(v'First+1..v'Last)));

begin
  for n in 1..10000 loop
    declare
      primes : Vector := prime_factors (n);
    begin
      if  primes'Length > 1 and then vector_digits_sum (primes) = digits_sum (n) then
        Ada.Text_IO.put (n'img);
      end if;
    end;
  end loop;
end smith;
