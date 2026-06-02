fn main() {
    let a: int[10] = [7, 10, 2, 4, 6, 1, 8, 3, 9, 5];
    let sum  = 0;
    let prod = 1;
    print "Array    : ";
    for e in a {
        sum  += e;
        prod *= e;
        print "{e} ";
    }
    println "";
    println "Sum      : {sum}";
    println "Product  : {prod}";
}
