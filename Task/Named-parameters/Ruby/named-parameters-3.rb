def example(opts = {})
  defaults = {:foo => 0, :bar => 1, :grill => "pork chops"}
  opts = defaults.merge(opts)
  printf("foo is %s, bar is %s, and grill is %s\n",
         opts[:foo], opts[:bar], opts[:grill])
end

example(:grill => "lamb kebab", :bar => 3.14)
