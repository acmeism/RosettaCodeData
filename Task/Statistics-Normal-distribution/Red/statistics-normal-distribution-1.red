Red [
    Title: "Ziggurat Normal Distribution Generator"
    Author: "hinjolicious"
    Notes: "Implements Marsaglia & Tsang's 128-layer Ziggurat method"
	credits: "Gemini AI"
]

ziggurat: context [
; standard normal distribution:
;	mean				0.0
;	standard deviation	1.0

;; --- Ziggurat Constants & Precomputed Tables for N = 128 ---
;; R is the tail boundary. For N = 128, R = 3.442619855899
zig-R: 3.442619855899
zig-V: 0.009902562274535 ;; Area of each layer

;; We construct lookup tables for fast-acceptance thresholds (K) and widths (W).
;; To keep code clean, we initialize them dynamically on script startup.
zig-K: make vector! [integer! 32 128]
zig-W: make vector! [float! 64 128]
zig-F: make vector! [float! 64 128] ;; Probability Density heights

init: does [
    local-f: func [x [float!]] [exp (-0.5 * x * x)]

    ;; Set up the edge case for the tail layer (layer 0)
    zig-W/1: (zig-V / local-f zig-R)
    zig-K/1: to integer! ((zig-R / zig-W/1) * 2147483647.0)
    zig-F/1: local-f zig-R

    zig-W/128: zig-R
    zig-K/128: 0
    zig-F/128: 1.0

    ;; Compute intermediate layers from bottom to top
    x: zig-R
    i: 127
    while [i > 1] [
        ;; Solve for next x position given equal area constraint
        x: sqrt (-2.0 * log-e ((zig-V / x) + local-f x))
        zig-W/:i: x
		
		;; Clamp the float value to 2147483647.0 before casting to prevent overflow
		zig-K/:i: to integer! min 2147483647.0 ((zig-W/(i + 1) / x) * 2147483647.0)
		
        zig-F/:i: local-f x
        i: i - 1
    ]
]

;; --- Core Ziggurat Generator ---
seq: function [
    "Returns a single normally distributed float (Mean=0, SD=1) one at a time"
] [
    ;; Fallback function for the rare tail extraction
    gaussian-tail: func [r [float!]] [
        x: 0.0 y: 0.0
        while [true] [
            x: (log-e (1.0 - ((random 2147483647) / 2147483647.0))) / (-1.0 * r)
            y: log-e (1.0 - ((random 2147483647) / 2147483647.0))
            if (-2.0 * y) > (x * x) [break]
        ]
        return r + x
    ]

    while [true] [
        ;; 1. Generate a random signed 32-bit integer range equivalent
        ;; Red's random returns 1-based index, so scale appropriately
        hz: (random 4294967295) - 2147483648

        ;; 2. Extract lower 7 bits to pick a random layer (1 to 128)
        idx: to integer! (absolute hz % 128) + 1

		;logs [hz idx]
        ;; 3. Fast Accept Path (Happens ~98% of the time)
        if (absolute hz) < zig-K/:idx [
            return hz * zig-W/:idx * 4.656612873077393e-10 ;; Scale 1/2^31
        ]

        ;; 4. Handle Edge Cases (Layer 128 is the top, Layer 1 is the bottom/tail)
        if idx == 128 [
            x: hz * zig-W/128 * 4.656612873077393e-10
            ;; Uniform point within the top layer box
            if ((random 2147483647) / 2147483647.0) < (exp (-0.5 * x * x)) [return x]
        ]

        if idx == 1 [
            ;; Fallback to Marsaglia's tail algorithm if it lands out in the wild tail
            tail-val: gaussian-tail zig-R
            return either hz < 0 [-1.0 * tail-val] [tail-val]
        ]

        ;; 5. Slow Rejection Path (Point sits in the 'overhang' zone)
        x: hz * zig-W/:idx * 4.656612873077393e-10
        y: zig-F/:idx + (((random 2147483647) / 2147483647.0) * (zig-F/(idx - 1) - zig-F/:idx))

        if y < (exp (-0.5 * x * x)) [
            return x
        ]
    ]
]

new: function [mu [float!] sigma [float!]][
	has [] bind
		[ seq * s + m ]
		object [m: mu s: sigma]
]

] ; /ziggurat context

;; Run table initialization once
ziggurat/init

; API
seq-ziggurat: :ziggurat/seq
; /API

comment {
;; --- Test Stream ---
print "Streaming 100 single normal numbers dynamically:"
loop 100 [print seq-ziggurat]

; new ziggurat normal distribution with a custom mean and stddev
print "IQ:"
iq: ziggurat/new 100.0 15.0
loop 100 [print iq]

}
