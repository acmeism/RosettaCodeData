constant @Stern-Brocot = 1, 1, { |(@_[$_ - 1] + @_[$_], @_[$_]) given ++$ } ... *;
 
put @Stern-Brocot[^15];
 
for flat 1..10, 100 -> $ix {
    say "First occurrence of {$ix.fmt('%3d')} is at index: {(1+@Stern-Brocot.first($ix, :k)).fmt('%4d')}";
}
 
say so 1 == all map ^1000: { [gcd] @Stern-Brocot[$_, $_ + 1] }
