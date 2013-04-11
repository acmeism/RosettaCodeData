   step_up ''            NB. output is sequence of falls & climbs required to climb one step.
_1 1 _1 _1 1 1 1
   +/\ _1 1 _1 _1 1 1 1  NB. running sum of output (current step relative to start)
_1 0 _1 _2 _1 0 1
   +/\ step_up ''        NB. another example
_1 _2 _3 _2 _3 _2 _1 _2 _3 _4 _3 _2 _3 _2 _3 _2 _3 _2 _1 _2 _1 _2 _1 0 1
