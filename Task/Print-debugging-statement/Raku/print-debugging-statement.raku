my &pdb = &die;

CATCH {
    when X::AdHoc {
        my @frames = .backtrace[*];
        say .payload;
        for @frames {
            # Filter out exception handing and dispatcher frames
            next if .file.contains: 'SETTING' or .subname.chars < 1;
            printf "%sfrom file: %s,%s line: %s\n",
              (' ' x $++), .file,
              (my $s = .subname) eq '<unit>' ?? '' !! " sub: $s,", .line;
        }
        say '';
        .resume;
    }
    default {}
}

## Testing / demonstration

# helper subs                #line 22
sub alpha ($a) {             #line 23
    pdb ('a =>', $a + 3);    #line 24
    pdb 'string';            #line 25
    beta(7);                 #line 26
}                            #line 27
sub beta  ($b) { pdb $b    } #line 28
sub gamma ($c) { beta $c   } #line 29
sub delta ($d) { gamma $d  } #line 30
                             #line 31
my $a = 10;                  #line 32
pdb (.VAR.name, $_) with $a; #line 33
alpha($a);                   #line 34
delta("Δ");                  #line 35
.&beta for ^3;               #line 36
