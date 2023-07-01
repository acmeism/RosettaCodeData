var DMAX  = 7  // maxmimum digits
var LIMIT = 19 // maximum number of Disariums to find

// Pre-calculated exponential and power serials
var EXP = List.filled(1 + DMAX, null)
var POW = List.filled(1 + DMAX, null)
EXP[0] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
EXP[1] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
POW[0] = List.filled(11, 0)
POW[1] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9]
for (i in 2..DMAX) {
    EXP[i] = List.filled(11, 0)
    POW[i] = List.filled(11, 0)
}
for (i in 1...DMAX) {
    for (j in 0..9) {
        EXP[i+1][j] = EXP[i][j] * 10
        POW[i+1][j] = POW[i][j] * j
    }
    EXP[i+1][10] = EXP[i][10] * 10
    POW[i+1][10] = POW[i][10] + POW[i+1][9]
}

// Digits of candidate and values of known low bits
var DIGITS = List.filled(1 + DMAX, 0)  // Digits form
var Exp    = List.filled(1 + DMAX, 0)  // Number form
var Pow    = List.filled(1 + DMAX, 0)  // Powers form

var exp
var pow
var min
var max
var start = 1
var final = DMAX
var count = 0
for (digit in start..final) {
    System.print("# of digits: %(digit)")
    var level = 1
    DIGITS[0] = 0
    while (true) {
        // Check limits derived from already known low bit values
        // to find the most possible candidates
        while (0 < level && level < digit) {
            // Reset path to try next if checking in level is done
            if (DIGITS[level] > 9) {
                DIGITS[level] = 0
                level = level - 1
                DIGITS[level] = DIGITS[level] + 1
                continue
            }

            // Update known low bit values
            Exp[level] = Exp[level - 1] + EXP[level][DIGITS[level]]
            Pow[level] = Pow[level - 1] + POW[digit + 1 - level][DIGITS[level]]

            // Max possible value
            pow = Pow[level] + POW[digit - level][10]

            if (pow < EXP[digit][1]) {  // Try next since upper limit is invalidly low
                DIGITS[level] = DIGITS[level] + 1
                continue
            }

            max = pow % EXP[level][10]
            pow = pow - max
            if (max < Exp[level]) pow = pow - EXP[level][10]
            max = pow + Exp[level]

            if (max < EXP[digit][1]) {  // Try next since upper limit is invalidly low
                DIGITS[level] = DIGITS[level] + 1
                continue
            }

            // Min possible value
            exp = Exp[level] + EXP[digit][1]
            pow = Pow[level] + 1

            if (exp > max || max < pow) { // Try next since upper limit is invalidly low
                DIGITS[level] = DIGITS[level] + 1
                continue
            }

            if (pow > exp ) {
                min = pow % EXP[level][10]
                pow = pow - min
                if (min > Exp[level]) {
                    pow = pow + EXP[level][10]
                }
                min = pow + Exp[level]
            } else {
                min = exp
            }

            // Check limits existence
            if (max < min) {
                DIGITS[level] = DIGITS[level] + 1  // Try next number since current limits invalid
            } else {
                level= level + 1  // Go for further level checking since limits available
            }
        }

        // All checking is done, escape from the main check loop
        if (level < 1) break

        // Finally check last bit of the most possible candidates
        // Update known low bit values
        Exp[level] = Exp[level - 1] + EXP[level][DIGITS[level]]
        Pow[level] = Pow[level - 1] + POW[digit + 1 - level][DIGITS[level]]

        // Loop to check all last bits of candidates
        while (DIGITS[level] < 10) {
            // Print out new Disarium number
            if (Exp[level] == Pow[level]) {
                var s = ""
                for (i in DMAX...0) s = s + DIGITS[i].toString
                System.print(Num.fromString(s))
                count = count + 1
                if (count == LIMIT) {
                    System.print("\nFound the first %(LIMIT) Disarium numbers.")
                    return
                }
            }

            // Go to followed last bit candidate
            DIGITS[level] = DIGITS[level] + 1
            Exp[level] = Exp[level] + EXP[level][1]
            Pow[level] = Pow[level] + 1
        }

        // Reset to try next path
        DIGITS[level] = 0
        level = level - 1
        DIGITS[level] = DIGITS[level] + 1
    }
    System.print()
}
