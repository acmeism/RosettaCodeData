> coffee numerical_integration.coffee
-- tests for cube with 100 steps from 0 to 1
left_rect 0.24502500000000005
mid_rect 0.24998750000000006
right_rect 0.25502500000000006
trapezium 0.250025
simpson 0.25
-- tests for reciprocal with 1000 steps from 1 to 100
left_rect 4.65499105751468
mid_rect 4.604762548678376
right_rect 4.55698105751468
trapezium 4.605986057514676
simpson 4.605170384957133
-- tests for identity with 5000000 steps from 0 to 5000
left_rect 12499997.5
mid_rect 12500000
right_rect 12500002.5
trapezium 12500000
simpson 12500000
-- tests for identity with 6000000 steps from 0 to 6000
left_rect 17999997.000000004
mid_rect 17999999.999999993
right_rect 18000003.000000004
trapezium 17999999.999999993
simpson 17999999.999999993
