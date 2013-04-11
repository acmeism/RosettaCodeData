begin
  # some code that may raise an exception
rescue ExceptionClassA => a
  # handle code
rescue ExceptionClassB, ExceptionClassC => b_or_c
  # handle ...
rescue
  # handle all other exceptions
else
  # when no exception occurred, execute this code
ensure
  # execute this code always
end
