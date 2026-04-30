proc print_all {args} {
    puts stdout [join $args \t]
}

print_all 4 3 5 6 4 3
4    3    5    6    4    3

print_all 4 3 5
4    3    5

print_all Rosetta Code Is Awesome!
Rosetta    Code    Is    Awesome!

print_all "Rosetta Code Is Awesome!" OK
Rosetta Code Is Awesome!    OK
