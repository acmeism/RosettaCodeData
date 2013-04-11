incrementer_rules = {
    :q0 => { 1  => [1, :right, :q0],
             :b => [1, :stay,  :qf]}
}
t = Turing.new([:b, 1],           # permitted symbols
               :b,                # blank symbol
               :q0,               # starting state
               [:qf],             # terminating states
               [:q0],             # running states
               incrementer_rules, # operating rules
               [1, 1, 1])         # starting tape
print t.run, "\n"
