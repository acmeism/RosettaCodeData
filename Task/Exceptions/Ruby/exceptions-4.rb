begin
  foo
rescue ArgumentError => e
  # rescues a MyInvalidArgument or any other ArgumentError
  bar
rescue => e
  # rescues a StandardError
  quack
else
  # runs if no exception occurred
  quux
ensure
  # always runs
  baz
end
