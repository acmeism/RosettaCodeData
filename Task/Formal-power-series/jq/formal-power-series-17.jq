# Verify that the first 100 terms of cos and (1 - I(sin)) are the same:

ps_equal( ps_cos; ps_at(0) - I(ps_sin); 100; 1e-5)
# => true

# Verify that the two power series agree at pi:

((pi | ps_evaluate(ps_cos)) - (pi | ps_evaluate(ps_at(0) - I(ps_sin)))) | abs < 1e-15
# => true
