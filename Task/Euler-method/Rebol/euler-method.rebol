Rebol [
    title: "Rosetta code: Euler method"
    file:  %Euler_method.r3
    url:   https://rosettacode.org/wiki/Euler_method
]

euler: func[
    "Euler's method for Newton's cooling law, with formatted comparison"
    step      [integer!] "time step in seconds"
    precision [decimal!] "rounding granularity for printed numbers"
][
    print ["^/STEP:" step]
    print "Time  Euler      Analytic"
    print "-------------------------"

    ;; Initialize:
    ;; b: upper time bound (seconds) — here we reuse the initial temperature value 100
    ;; y: the current Euler-approximated temperature; initial condition T(0) = 100
    b: y: 100
    for time 0 b step [
        printf [-3 " | " 9 "| "] reduce [
            time
            round/to y precision
            round/to (20 + (80 * exp (-0.07 * time))) precision
        ]
        ;; Euler step update:
        ;; This applies the discrete forward Euler update using the ODE's RHS
        y: y + (step * (-0.07 * (y - 20)))
    ]
]
;; Run three experiments with different step sizes
euler 2  0.0001
euler 5  0.0001
euler 10 0.0001
