sub print_many ($first, $second, @rest) {
    say "First: $first\n"
       ."Second: $second\n"
       ."And the rest: "
       . join("\n", @rest);
}
