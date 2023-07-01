use 5.10.0;

sub count_up
{
    state $foo = 13;
    say $foo++;
}

count_up;                 # Prints "13".
count_up;                 # Prints "14".
