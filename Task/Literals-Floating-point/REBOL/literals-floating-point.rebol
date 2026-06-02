;; Rebol has 64bit decimals like:
2.3
0.3e+34
1.#INF -1.#INF
1.#NaN
;; It can store 32bit decimals in vectors:
#(float32! [1 2])
;== #(float32! [1.0 2.0])
to-binary #(float32! [1 2])
;== #{0000803F00000040}
to-binary #(float64! [1 2])
;== #{000000000000F03F0000000000000040}

;; Rebol3 also has "binary" dialect for reading decimals from binary streams
binary/read #{0000803F0000000000000040} [f32 f64]
;== [1.0 2.0]
