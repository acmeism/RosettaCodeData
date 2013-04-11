sub mfact($n, :$degree = 1) { [*] $n, *-$degree ...^ * <= 0 }

for 1 .. 5 -> $degree {
    say "$degree: ", map &mfact.assuming(:$degree), 1 .. 10;
}
