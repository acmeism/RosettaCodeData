use Lingua::EN::Numbers;
use ntheory:from<Perl5> <factor is_prime>;

sub display ($n,$m) { ($n..$m).grep: (~*).&factor.elems.&is_prime }

sub count ($n,$m) { +($n..$m).grep: (~*).&factor.elems.&is_prime }

# The Task
put "Attractive numbers from 1 to 120:\n" ~
display(1, 120)».fmt("%3d").rotor(20, :partial).join: "\n";

# Robusto!
for 1, 1000,  1, 10000, 1, 100000, 2**73 + 1, 2**73 + 100 -> $a, $b {
    put "\nCount of attractive numbers from {comma $a} to {comma $b}:\n" ~
    comma count $a, $b
}
