def example(opts = {})
  # Hash#merge raises TypeError if _opts_ is not a Hash.
  # Nothing checks if _opts_ contains unknown keys.
  defaults = {foo: 0, bar: 1, grill: "pork chops"}
  opts = defaults.merge(opts)

  printf("foo is %s, bar is %s, and grill is %s\n",
         opts[:foo], opts[:bar], opts[:grill])
end

example(grill: "lamb kebab", bar: 3.14)
