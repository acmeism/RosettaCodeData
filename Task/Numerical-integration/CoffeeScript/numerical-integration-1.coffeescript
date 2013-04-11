rules =
  left_rect: (f, x, h) -> f(x)
  mid_rect: (f, x, h) -> f(x+h/2)
  right_rect: (f, x, h) -> f(x+h)
  trapezium: (f, x, h) -> (f(x) + f(x+h)) / 2
  simpson: (f, x, h) -> (f(x) + 4 * f(x + h/2) + f(x+h)) / 6

functions =
  cube: (x) -> x*x*x
  reciprocal: (x) -> 1/x
  identity: (x) -> x

sum = (list) -> list.reduce ((a, b) -> a+b), 0

integrate = (f, a, b, steps, meth) ->
   h = (b-a) / steps
   h * sum(meth(f, a+i*h, h) for i in [0...steps])

# Tests
tests = [
  [0, 1, 100, 'cube']
  [1, 100, 1000, 'reciprocal']
  [0, 5000, 5000000, 'identity']
  [0, 6000, 6000000, 'identity']
]

for test in tests
  [a, b, steps, func_name] = test
  func = functions[func_name]
  console.log "-- tests for #{func_name} with #{steps} steps from #{a} to #{b}"
  for rule_name, rule of rules
    result = integrate func, a, b, steps, rule
    console.log rule_name, result
