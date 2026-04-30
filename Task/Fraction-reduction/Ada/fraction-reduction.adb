with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;
procedure Fraction_Reduction is

type Int_Array is array (Natural range <>) of Integer;

function indexOf(haystack : Int_Array; needle : Integer) return Integer is
    idx : Integer := 0;
begin
    for straw of haystack loop
        if straw = needle then
            return idx;
        else
            idx := idx + 1;
        end if;
    end loop;
    return -1;
end IndexOf;

function getDigits(n, le : in Integer;
                   digit_array : in out Int_Array) return Boolean is
    n_local : Integer := n;
    le_local : Integer := le;
    r : Integer;
begin
    while n_local > 0 loop
        r := n_local mod 10;
        if r = 0 or indexOf(digit_array, r) >= 0 then
            return False;
        end if;
        le_local := le_local - 1;
        digit_array(le_local) := r;
        n_local := n_local / 10;
    end loop;
    return True;
end getDigits;

function removeDigit(digit_array : Int_Array;
                     le, idx : Integer) return Integer is
    sum : Integer := 0;
    pow : Integer := 10 ** (le - 2);
begin
    for i in 0 .. le - 1 loop
        if i /= idx then
            sum := sum + digit_array(i) * pow;
            pow := pow / 10;
        end if;
    end loop;
    return sum;
end removeDigit;

    lims : constant array (0 .. 3) of Int_Array (0 .. 1) :=
       ((12, 97), (123, 986), (1234, 9875), (12345, 98764));
    count : Int_Array (0 .. 4) := (others => 0);
    omitted : array (0 .. 4) of Int_Array (0 .. 9) :=
       (others => (others => 0));
begin
    Ada.Integer_Text_IO.Default_Width := 0;
    for i in lims'Range loop
        declare
            nDigits, dDigits : Int_Array (0 .. i + 1);
            digit, dix, rn, rd : Integer;
        begin
            for n in lims(i)(0) .. lims(i)(1) loop
                nDigits := (others => 0);
                if getDigits(n, i + 2, nDigits) then
                    for d in n + 1 .. lims(i)(1) + 1 loop
                        dDigits := (others => 0);
                        if getDigits(d, i + 2, dDigits) then
                            for nix in nDigits'Range loop
                                digit := nDigits(nix);
                                dix := indexOf(dDigits, digit);
                                if dix >= 0 then
                                    rn := removeDigit(nDigits, i + 2, nix);
                                    rd := removeDigit(dDigits, i + 2, dix);
                                    -- 'n/d = rn/rd' is same as 'n*rd = rn*d'
                                    if n*rd = rn*d then
                                        count(i) := count(i) + 1;
                                        omitted(i)(digit) :=
                                           omitted(i)(digit) + 1;
                                        if count(i) <= 12 then
                                            Put (n);
                                            Put ("/");
                                            Put (d);
                                            Put (" = ");
                                            Put (rn);
                                            Put ("/");
                                            Put (rd);
                                            Put (" by omitting ");
                                            Put (digit);
                                            Put_Line ("'s");
                                        end if;
                                    end if;
                                end if;
                            end loop;
                        end if;
                    end loop;
                end if;
            end loop;
        end;
        New_Line;
    end loop;
    for i in 2 .. 5 loop
        Put ("There are ");
        Put (count(i - 2));
        Put (" ");
        Put (i);
        Put_Line ("-digit fractions of which:");
        for j in 1 .. 9 loop
            if omitted(i - 2)(j) /= 0 then
                Put (omitted(i - 2)(j), Width => 6);
                Put (" have ");
                Put (j);
                Put_Line ("'s omitted");
            end if;
        end loop;
        New_Line;
    end loop;

end Fraction_Reduction;
