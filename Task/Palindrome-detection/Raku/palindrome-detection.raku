subset Palindrom of Str where {
    .flip eq $_ given .comb(/\w+/).join.lc
}

my @tests = q:to/END/.lines;
    A man, a plan, a canal: Panama.
    My dog has fleas
    Madam, I'm Adam.
    1 on 1
    In girum imus nocte et consumimur igni
    END

for @tests { say $_ ~~ Palindrom, "\t", $_ }
