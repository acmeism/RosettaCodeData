generate {|p| {out: $p.0 next: [($p.0 + $p.1) ($p.1 + 8)]} } [1, 8]
| skip until { $in > 99 }
| take while { $in < 1000 }
| str join ' '
