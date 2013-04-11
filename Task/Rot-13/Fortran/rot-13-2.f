> cat foo.txt
foo
> cat bar.txt
bar
> ./rot_13 foo.txt bar.txt
sbb
one
> ./rot_13 < foo.txt
sbb
> cat foo.txt bar.txt | ./rot_13
sbb
one
