with Ada.Text_IO;use Ada.Text_IO;
procedure modular_inverse is
  -- inv_mod calculates the inverse of a mod n. We should have n>0 and, at the end, the contract is a*Result=1 mod n
  -- If this is false then we raise an exception (don't forget the -gnata option when you compile
  function inv_mod (a : Integer; n : Positive) return Integer with post=> (a * inv_mod'Result) mod n = 1 is
    -- To calculate the inverse we do as if we would calculate the GCD with the Euclid extended algorithm
    -- (but we just keep the coefficient on a)
    function inverse (a, b, u, v : Integer) return Integer is (if b=0 then u else inverse (b, a mod b, v, u-(v*a)/b));
  begin
    return inverse (a, n, 1, 0);
  end inv_mod;
begin
  -- This will output -48 (which is correct)
  Put_Line (inv_mod (42,2017)'img);
  -- The further line will raise an exception since the GCD will not be 1
  Put_Line (inv_mod (42,77)'img);
  exception when others => Put_Line ("The inverse doesn't exist.");
end bitmap;
