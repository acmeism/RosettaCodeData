sub compound-duration ($seconds) {
    ($seconds.polymod(60, 60, 24, 7) Z <sec min hr d wk>)
    .grep(*[0]).reverse.join(", ")
}

# Demonstration:

for 7259, 86400, 6000000 {
    say "{.fmt: '%7d'} sec  =  {compound-duration $_}";
}
