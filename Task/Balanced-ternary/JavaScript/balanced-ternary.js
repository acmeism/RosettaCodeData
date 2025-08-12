class BTernary {
    constructor(input) {
        if (typeof input === 'string') {
            let i = 0;
            while (i < input.length && input.charAt(i) === '0') {
                i++;
            }
            this.value = input.substring(i);
        } else if (typeof input === 'number') {
            this.value = this.convertToBT(input);
        }
    }

    convertToBT(v) {
        if (v < 0) {
            return this.flip(this.convertToBT(-v));
        }
        if (v === 0) {
            return "";
        }
        const rem = this.mod3(v);
        if (rem === 0) {
            return this.convertToBT(Math.floor(v / 3)) + "0";
        }
        if (rem === 1) {
            return this.convertToBT(Math.floor(v / 3)) + "+";
        }
        if (rem === 2) {
            return this.convertToBT(Math.floor((v + 1) / 3)) + "-";
        }
        return "You can't see me";
    }

    flip(s) {
        let flip = "";
        for (let i = 0; i < s.length; i++) {
            if (s.charAt(i) === '+') {
                flip += '-';
            } else if (s.charAt(i) === '-') {
                flip += '+';
            } else {
                flip += '0';
            }
        }
        return flip;
    }

    mod3(v) {
        if (v > 0) {
            return v % 3;
        }
        v = v % 3;
        return (v + 3) % 3;
    }

    intValue() {
        let sum = 0;
        const s = this.value;
        for (let i = 0; i < s.length; i++) {
            const c = s.charAt(s.length - i - 1);
            let dig = 0;
            if (c === '+') {
                dig = 1;
            } else if (c === '-') {
                dig = -1;
            }
            sum += dig * Math.pow(3, i);
        }
        return sum;
    }

    add(that) {
        let a = this.value;
        let b = that.value;

        const longer = a.length > b.length ? a : b;
        let shorter = a.length > b.length ? b : a;

        while (shorter.length < longer.length) {
            shorter = '0' + shorter;
        }

        a = longer;
        b = shorter;

        let carry = '0';
        let sum = "";
        for (let i = 0; i < a.length; i++) {
            const place = a.length - i - 1;
            const digisum = this.addDigitsWithCarry(a.charAt(place), b.charAt(place), carry);
            if (digisum.length !== 1) {
                carry = digisum.charAt(0);
            } else {
                carry = '0';
            }
            sum = digisum.charAt(digisum.length - 1) + sum;
        }
        sum = carry + sum;

        return new BTernary(sum);
    }

    addDigitsWithCarry(a, b, carry) {
        const sum1 = this.addDigits(a, b);
        const sum2 = this.addDigits(sum1.charAt(sum1.length - 1), carry);

        if (sum1.length === 1) {
            return sum2;
        }
        if (sum2.length === 1) {
            return sum1.charAt(0) + sum2;
        }
        return sum1.charAt(0) + "";
    }

    addDigits(a, b) {
        let sum = "";
        if (a === '0') {
            sum = b + "";
        } else if (b === '0') {
            sum = a + "";
        } else if (a === '+') {
            if (b === '+') {
                sum = "+-";
            } else {
                sum = "0";
            }
        } else {
            if (b === '+') {
                sum = "0";
            } else {
                sum = "-+";
            }
        }
        return sum;
    }

    neg() {
        return new BTernary(this.flip(this.value));
    }

    sub(that) {
        return this.add(that.neg());
    }

    mul(that) {
        const one = new BTernary(1);
        const zero = new BTernary(0);
        let mul = new BTernary(0);

        let flipflag = 0;
        if (that.compareTo(zero) === -1) {
            that = that.neg();
            flipflag = 1;
        }

        for (let i = new BTernary(1); i.compareTo(that) < 1; i = i.add(one)) {
            mul = mul.add(this);
        }

        if (flipflag === 1) {
            mul = mul.neg();
        }
        return mul;
    }

    equals(that) {
        return this.value === that.value;
    }

    compareTo(that) {
        if (this.intValue() > that.intValue()) {
            return 1;
        } else if (this.equals(that)) {
            return 0;
        }
        return -1;
    }

    toString() {
        return this.value;
    }
}

// Main execution
function main() {
    const a = new BTernary("+-0++0+");
    const b = new BTernary(-436);
    const c = new BTernary("+-++-");

    console.log("a=" + a.intValue());
    console.log("b=" + b.intValue());
    console.log("c=" + c.intValue());
    console.log();

    // result = a * (b - c)
    const result = a.mul(b.sub(c));

    console.log("result= " + result + " " + result.intValue());
}

// Run the main function
main();
