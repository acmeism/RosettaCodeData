# Verify that the first 100 terms of I(cos) and of sin are the same:

ps_equal( I(ps_cos); ps_sin; 100; 1e-15)
# => true

# Verify that the two power series agree when evaluated at pi:

((pi | ps_evaluate(I(ps_cos))) - (pi | ps_evaluate(ps_sin))) | abs < 1e-15
# => true
