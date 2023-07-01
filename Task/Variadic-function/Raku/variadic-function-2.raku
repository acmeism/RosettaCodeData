sub foo (*@positional, *%named) {
   .say for @positional;
   say .key, ': ', .value for %named;
}
