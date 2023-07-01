import "/fmt" for Fmt

System.print("The first 61 numbers in the fusc sequence are:")
var fusc = [0, 1]
var fusc2 = [[0, 0]]
var maxLen = 1
var n = 2
while (n < 20e6) { // limit to indices under 20 million say
    var f  = (n % 2  == 0) ? fusc[n/2] : fusc[(n-1)/2] + fusc[(n+1)/2]
    fusc.add(f)
    var len = "%(f)".count
    if (len > maxLen) {
        maxLen = len
        if (n <= 60) {
            fusc2.add([n, f])
        } else {
            System.print("%(Fmt.dc(10, n))  %(Fmt.dc(0, f))")
        }
    }
    if (n == 60 ) {
        for (f in fusc) System.write("%(f) ")
        System.print("\n\nFirst terms longer than any previous ones for indices < 20,000,000:")
        System.print("     Index  Value")
        for (iv in fusc2) System.print("%(Fmt.d(10, iv[0]))  %(iv[1])")
    }
    n = n + 1
}
