def main:
    (range(2; 11) | "fib(\(.)): \(fib(.; 15))"),
    (range(2; 11) | "lucas(\(.)): \(lucas(.; 15))")
;

main
