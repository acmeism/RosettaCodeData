package require opt
tcl::OptProc example {
    {-foo   -int   0           "The number of foos"}
    {-bar   -float 1.0         "How much bar-ness"}
    {-grill -any   "hamburger" "What to cook on the grill"}
} {
    return "foo is $foo, bar is $bar, and grill is $grill"
}
example -grill "lamb kebab" -bar 3.14
# => ‘foo is 0, bar is 3.14, and grill is lamb kebab’
example -help
# Usage information:
#     Var/FlagName Type  Value       Help
#     ------------ ----  -----       ----
#     ( -help                        gives this help )
#     -foo         int   (0)         The number of foos
#     -bar         float (1.0)       How much bar-ness
#     -grill       any   (hamburger) What to cook on the grill
