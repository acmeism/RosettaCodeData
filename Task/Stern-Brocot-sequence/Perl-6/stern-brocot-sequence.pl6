constant Stern-Brocot = flat
    1, 1, -> *@a {
        @a[$_ - 1] + @a[$_], @a[$_] given ++$;
    } ... *;

say Stern-Brocot[^15];

for 1 .. 10, 100 -> $ix {
    say "first occurrence of $ix is at index : ", 1 + Stern-Brocot.first-index($ix);
}

say so 1 == all map ^1000: { [gcd] Stern-Brocot[$_, $_ + 1] }
