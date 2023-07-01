import Cocoa

class LinearCongruntialGenerator {

    var state = 0 //seed of 0 by default
    let a, c, m, shift: Int

    //we will use microsoft random by default
    init() {
        self.a = 214013
        self.c = 2531011
        self.m = Int(pow(2.0, 31.0)) //2^31 or 2147483648
        self.shift = 16
    }

    init(a: Int, c: Int, m: Int, shift: Int) {
        self.a = a
        self.c = c
        self.m = m //2^31 or 2147483648
        self.shift = shift
    }

    func seed(seed: Int) -> Void {
        state = seed;
    }

    func random() -> Int {
        state = (a * state + c) % m
        return state >> shift
    }
}

let microsoftLinearCongruntialGenerator = LinearCongruntialGenerator()
let BSDLinearCongruntialGenerator = LinearCongruntialGenerator(a: 1103515245, c: 12345, m: 2147483648, shift: 0)

print("Microsft Rand:")
for(var i = 0; i < 10; i++)
{
    print(microsoftLinearCongruntialGenerator.random())
}

print("") //new line for readability
print("BSD Rand:")
for(var i = 0; i < 10; i++)
{
    print(BSDLinearCongruntialGenerator.random())
}
