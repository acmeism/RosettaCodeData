def pad(n): tostring | . + (n - length) * " ";

"                 i:      gamma                lanczos              tgamma",
(range(1;11)
 | . / 3.0
 | "\(pad(18)): \(gamma|pad(18)) : \(gamma_by_lanczos|pad(18)) : \(tgamma)")
