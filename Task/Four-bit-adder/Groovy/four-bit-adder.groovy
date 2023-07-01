class Main {
    static void main(args) {

        def bit1, bit2, bit3, bit4, carry

        def fourBitAdder = new FourBitAdder(
                { value -> bit1 = value },
                { value -> bit2 = value },
                { value -> bit3 = value },
                { value -> bit4 = value },
                { value -> carry = value }
        )

        // 5 + 6 = 11

        // 0101 i.e. 5
        fourBitAdder.setNum1Bit1 false
        fourBitAdder.setNum1Bit2 true
        fourBitAdder.setNum1Bit3 false
        fourBitAdder.setNum1Bit4 true

        // 0110 i.e 6
        fourBitAdder.setNum2Bit1 false
        fourBitAdder.setNum2Bit2 true
        fourBitAdder.setNum2Bit3 true
        fourBitAdder.setNum2Bit4 false

        def boolToInt = { bool ->
            bool ? 1 : 0
        }

        println ("0101 + 0110 = ${boolToInt(bit1)}${boolToInt(bit2)}${boolToInt(bit3)}${boolToInt(bit4)}")
    }
}

class Not {
    Closure output

    Not(output) {
        this.output = output
    }

    def setInput(input) {
        output !input
    }
}

class And {
    boolean input1
    boolean input2
    Closure output

    And(output) {
        this.output = output
    }

    def setInput1(input) {
        this.input1 = input
        output(input1 && input2)
    }

    def setInput2(input) {
        this.input2 = input
        output(input1 && input2)
    }
}

class Nand {
    And andGate
    Not notGate

    Nand(output) {
        notGate = new Not(output)
        andGate = new And({ value ->
            notGate.setInput value
        })
    }

    def setInput1(input) {
        andGate.setInput1 input
    }

    def setInput2(input) {
        andGate.setInput2 input
    }
}

class Or {
    Not firstInputNegation
    Not secondInputNegation
    Nand nandGate

    Or(output) {
        nandGate = new Nand(output)
        firstInputNegation = new Not({ value ->
            nandGate.setInput1 value
        })
        secondInputNegation = new Not({ value ->
            nandGate.setInput2 value
        })
    }

    def setInput1(input) {
        firstInputNegation.setInput input
    }

    def setInput2(input) {
        secondInputNegation.setInput input
    }
}

class Xor {
    And andGate
    Or orGate
    Nand nandGate

    Xor(output) {
        andGate = new And(output)
        orGate = new Or({ value ->
            andGate.setInput1 value
        })
        nandGate = new Nand({ value ->
            andGate.setInput2 value
        })

    }

    def setInput1(input) {
        orGate.setInput1 input
        nandGate.setInput1 input
    }

    def setInput2(input) {
        orGate.setInput2 input
        nandGate.setInput2 input
    }
}

class Adder {
    Or orGate
    Xor xorGate1
    Xor xorGate2
    And andGate1
    And andGate2

    Adder(sumOutput, carryOutput) {
        xorGate1 = new Xor(sumOutput)
        orGate = new Or(carryOutput)
        andGate1 = new And({ value ->
            orGate.setInput1 value
        })
        xorGate2 = new Xor({ value ->
            andGate1.setInput1 value
            xorGate1.setInput1 value
        })
        andGate2 = new And({ value ->
            orGate.setInput2 value
        })
    }

    def setBit1(input) {
        xorGate2.setInput1 input
        andGate2.setInput2 input
    }

    def setBit2(input) {
        xorGate2.setInput2 input
        andGate2.setInput1 input
    }

    def setCarry(input) {
        andGate1.setInput2 input
        xorGate1.setInput2 input
    }
}

class FourBitAdder {
    Adder adder1
    Adder adder2
    Adder adder3
    Adder adder4

    FourBitAdder(bit1, bit2, bit3, bit4, carry) {
        adder1 = new Adder(bit1, carry)
        adder2 = new Adder(bit2, { value ->
            adder1.setCarry value
        })
        adder3 = new Adder(bit3, { value ->
            adder2.setCarry value
        })
        adder4 = new Adder(bit4, { value ->
            adder3.setCarry value
        })
    }

    def setNum1Bit1(input) {
        adder1.setBit1 input
    }

    def setNum1Bit2(input) {
        adder2.setBit1 input
    }

    def setNum1Bit3(input) {
        adder3.setBit1 input
    }

    def setNum1Bit4(input) {
        adder4.setBit1 input
    }

    def setNum2Bit1(input) {
        adder1.setBit2 input
    }

    def setNum2Bit2(input) {
        adder2.setBit2 input
    }

    def setNum2Bit3(input) {
        adder3.setBit2 input
    }

    def setNum2Bit4(input) {
        adder4.setBit2 input
    }
}
