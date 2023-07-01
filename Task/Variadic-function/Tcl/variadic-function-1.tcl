proc print_all {args} {puts [join $args \n]}

print_all 4 3 5 6 4 3
print_all 4 3 5
print_all Rosetta Code Is Awesome!

set things {Rosetta Code Is Awesome!}

print_all $things ;# ==> incorrect: passes a single argument (a list) to print_all
print_all {*}$things ;# ==> correct: passes each element of the list to the procedure
