if condition
  statement
end
# can be written as:
statement if condition   # the same with unless

v = begin
      expression
    rescue
      value
    end
# can be written as:
v = expression rescue value

begin
  statement
ensure
  always_run
end
# can be written as:
statement ensure always_run
