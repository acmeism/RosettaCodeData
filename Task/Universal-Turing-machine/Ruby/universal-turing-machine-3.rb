busy_beaver_rules = {
    :a => { 0 => [1, :right, :b],
            1 => [1, :left,  :c]},
    :b => { 0 => [1, :left,  :a],
            1 => [1, :right, :b]},
    :c => { 0 => [1, :left,  :b],
            1 => [1, :stay,  :halt]}
}
t = Turing.new([0, 1],            # permitted symbols
               0,                 # blank symbol
               :a,                # starting state
               [:halt],           # terminating states
               [:a, :b, :c],      # running states
               busy_beaver_rules, # operating rules
               [])                # starting tape
print t.run, "\n"
