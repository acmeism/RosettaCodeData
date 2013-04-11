multi sub MAIN() { MAIN(0, 100) }
multi sub MAIN($min is copy where ($min >= 0), $max is copy where ($max > $min)) {
    say "Think of a number between $min and $max and I'll guess it!";
    while $min <= $max {
        my $guess = (($max + $min)/2).floor;
        given lc prompt "My guess is $guess. Is your number higher, lower or equal? " {
            when /^e/ { say "I knew it!"; exit }
            when /^h/ { $min = $guess + 1      }
            when /^l/ { $max = $guess          }
            default   { say "WHAT!?!?!"        }
        }
    }
    say "How can your number be both higher and lower than $max?!?!?";
}
