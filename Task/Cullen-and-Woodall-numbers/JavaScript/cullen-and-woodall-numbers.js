const bigInt = require('big-integer');
class CullenAndWoodhall {
    static main() {
        this.numberSequence(20, NumberType.Cullen);
        this.numberSequence(20, NumberType.Woodhall);
        this.primeSequence(5, NumberType.Cullen);
        this.primeSequence(12, NumberType.Woodhall);
    }
    static numberSequence(aCount, aNumberType) {
        console.log();
        console.log(`The first ${aCount} ${aNumberType} numbers are:`);
        this.numberInitialise();
        for (let index = 1; index <= aCount; index++) {
            process.stdout.write(this.nextNumber(aNumberType).toString() + " ");
        }
        console.log();
    }
    static primeSequence(aCount, aNumberType) {
        console.log();
        console.log(`The indexes of the first ${aCount} ${aNumberType} primes are:`);
        this.primeInitialise();
        while (this.count < aCount) {
            if (this.nextNumber(aNumberType).isProbablePrime(20)) {
                process.stdout.write(this.primeIndex + " ");
                this.count += 1;
            }
            this.primeIndex += 1;
        }
        console.log();
    }
    static nextNumber(aNumberType) {
        this.number = this.number.add(1);
        this.power = this.power.shiftLeft(1);
        if (aNumberType === NumberType.Cullen) {
            return this.number.multiply(this.power).add(1);
        } else {
            return this.number.multiply(this.power).subtract(1);
        }
    }
    static numberInitialise() {
        this.number = bigInt(0);
        this.power = bigInt(1);
    }
    static primeInitialise() {
        this.count = 0;
        this.primeIndex = 1;
        this.numberInitialise();
    }
    static number = bigInt(0);
    static power = bigInt(1);
    static count = 0;
    static primeIndex = 0;
    static CERTAINTY = 20;
}
const NumberType = {
    Cullen: "Cullen",
    Woodhall: "Woodhall"
};
CullenAndWoodhall.main();
