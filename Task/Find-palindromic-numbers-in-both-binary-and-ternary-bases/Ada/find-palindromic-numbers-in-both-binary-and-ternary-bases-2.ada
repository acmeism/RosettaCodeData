with Ada.Text_IO, Ada.Unchecked_Conversion;use Ada.Text_IO;
procedure Palindromic is
  type Int is mod 2**64; -- the size of the unsigned values we will test doesn't exceed 64 bits

  type Bits is array (0..63) of Boolean;
    for Bits'Component_Size use 1;

  -- This function allows us to get the i'th bit of an Int k by writing Int_To_Bits(k)(i)
  function Int_To_Bits is new Ada.Unchecked_Conversion(Int,Bits);

  -- an inline function to test if k is palindromic in a very efficient way since we leave the loop
  -- as soon as two bits are not symmetric). Number_Of_Digits is the number of digits (in base 2) of k minus 1
  function Is_Pal2 (k : Int;Number_Of_Digits : Natural) return Boolean is
  (for all i in 0..Number_Of_Digits=>Int_To_Bits(k)(i)=Int_To_Bits(k)(Number_Of_Digits-i));

  function Reverse_Number (k : Int) return Int is --returns the symmetric representation of k (base-3)
    n : Int := 0;
    p : Int := k;
  begin
    while 0<p loop
      n := n * 3 + p mod 3;
      p := p / 3;
    end loop;
    return n;
  end reverse_number;

  procedure Print (n : Int) is
    package BC is new Ada.Text_IO.Modular_IO (Int); use BC; -- allows us to express a variable of modular type in a given base
  begin
     Put (n, Base=>2, Width=>65); Put (n, Base=>3, Width=>45); put_line (" " & n'Img);
  end Print;

  p3, n, bound, count_pal: Int := 1;
begin
  Print (0); -- because 0 is the special case asked to be treated, that is why count_pal=1
  Process_Each_Power_Of_4 : for p in 0..31 loop -- because 4^p < 2^64
    -- adjust the 3-power of the number to test so that the palindrome built with it has an odd number of digits in base-2
    while (3*p3+1)*p3 < 2**(2*p) loop p3 := 3*p3;end loop;
    bound := 2**(2*p)/(3*p3);
    for k in Int range Int'Max(p3/3, bound) .. Int'Min (2*bound,p3-1) loop
      n := (3*k+1)*p3 + Reverse_Number (k); -- n is a 2p+1 digits number in base 2 and is a palindrome in base 3.
      if Is_Pal2 (n, 2*p) then
        Print (n);
        count_pal := count_pal + 1;
        exit Process_Each_Power_Of_4 when count_pal = 7;
      end if;
    end loop;
  end loop Process_Each_Power_Of_4;
end Palindromic;
