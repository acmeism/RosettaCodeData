import "./gmp" for Mpz
import "./fmt" for Fmt

var tests = ["13", "4294967213", "9759463979", "34225158206557151", "763218146048580636353"]
for (test in tests) {
    var bi = Mpz.fromStr(test)
    var fac = Mpz.pollardRho(bi)
    if (fac > Mpz.zero) {
        Fmt.print("$i = $i * $i ($i bits)", bi, fac, bi/fac, bi.sizeInBits)
    } else {
        Fmt.print("$i : $s", bi, "Pollard's Rho failed to find a factor.")
    }
}
