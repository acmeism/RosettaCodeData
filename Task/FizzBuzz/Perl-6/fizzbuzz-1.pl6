for 1 .. 100 {
    when $_ %% (3 & 5) { say 'FizzBuzz'; }
    when $_ %% 3       { say 'Fizz'; }
    when $_ %% 5       { say 'Buzz'; }
    default            { .say; }
}
