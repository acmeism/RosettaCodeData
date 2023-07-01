sub price-fraction ($n where 0..1) {
    when $n < 0.06 { 0.10 }
    when $n < 0.11 { 0.18 }
    when $n < 0.16 { 0.26 }
    when $n < 0.21 { 0.32 }
    when $n < 0.26 { 0.38 }
    when $n < 0.31 { 0.44 }
    when $n < 0.36 { 0.50 }
    when $n < 0.41 { 0.54 }
    when $n < 0.46 { 0.58 }
    when $n < 0.51 { 0.62 }
    when $n < 0.56 { 0.66 }
    when $n < 0.61 { 0.70 }
    when $n < 0.66 { 0.74 }
    when $n < 0.71 { 0.78 }
    when $n < 0.76 { 0.82 }
    when $n < 0.81 { 0.86 }
    when $n < 0.86 { 0.90 }
    when $n < 0.91 { 0.94 }
    when $n < 0.96 { 0.98 }
    default        { 1.00 }
}

while prompt("value: ") -> $value {
    say price-fraction(+$value);
}
