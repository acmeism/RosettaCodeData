Red[]
seed: 675248
rand: does [seed: to-integer (seed * 1.0 * seed / 1000) % 1000000]  ; multiply by 1.0 to avoid integer overflow (32-bit)
loop 5 [print rand]
