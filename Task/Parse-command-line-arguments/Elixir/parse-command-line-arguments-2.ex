$ ./parse-args.exs --a --b --c=yes --no-flag --verbose -V -a=1 -b=t -- apple banana
Arguments:
{[a: true, b: true, c: "yes", no_flag: true, verbose: true],
 ["apple", "banana"], [{"-V", nil}, {"-a", "1"}, {"-b", "t"}]}
