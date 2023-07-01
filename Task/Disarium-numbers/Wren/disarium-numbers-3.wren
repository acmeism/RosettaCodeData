import "./i64" for U64

var DMAX  = 20 // maxmimum digits
var LIMIT = 20 // maximum number of disariums to find

// Pre-calculated exponential and power serials
var EXP = List.filled(1 + DMAX, null)
var POW = List.filled(1 + DMAX, null)
EXP[0]  = List.filled(11, null)
EXP[1]  = List.filled(11, null)
POW[0]  = List.filled(11, null)
POW[1]  = List.filled(11, null)
for (i in 0..9) EXP[0][i] = U64.zero
EXP[0][10] = U64.one

for (i in 0..10) EXP[1][i] = U64.from(i)

for (i in 0..10) POW[0][i] = U64.zero

for (i in 0..9) POW[1][i] = U64.from(i)
POW[1][10] = U64.from(9)

for (i in 2..DMAX) {
    EXP[i] = List.filled(11, null)
    POW[i] = List.filled(11, null)
    for (j in 0..10) {
        EXP[i][j] = U64.zero
        POW[i][j] = U64.zero
    }
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
var Exp    = List.filled(1 + DMAX, null)  // Number form
var Pow    = List.filled(1 + DMAX, null)  // Powers form
for (i in 0..DMAX) {
    Exp[i] = U64.zero
    Pow[i] = U64.zero
}

var exp = U64.new()
var pow = U64.new()
var min = U64.new()
var max = U64.new()
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
            Exp[level].add(Exp[level - 1], EXP[level][DIGITS[level]])
            Pow[level].add(Pow[level - 1], POW[digit + 1 - level][DIGITS[level]])

            // Max possible value
            pow.add(Pow[level], POW[digit - level][10])

            if (pow < EXP[digit][1]) {  // Try next since upper limit is invalidly low
                DIGITS[level] = DIGITS[level] + 1
                continue
            }

            max.rem(pow, EXP[level][10])
            pow.sub(max)
            if (max < Exp[level]) pow.sub(EXP[level][10])
            max.add(pow, Exp[level])

            if (max < EXP[digit][1]) {  // Try next since upper limit is invalidly low
                DIGITS[level] = DIGITS[level] + 1
                continue
            }

            // Min possible value
            exp.add(Exp[level], EXP[digit][1])
            pow.add(Pow[level], 1)

            if (exp > max || max < pow) { // Try next since upper limit is invalidly low
                DIGITS[level] = DIGITS[level] + 1
                continue
            }

            if (pow > exp ) {
                min.rem(pow, EXP[level][10])
                pow.sub(min)
                if (min > Exp[level]) {
                    pow.add(EXP[level][10])
                }
                min.add(pow, Exp[level])
            } else {
                min.set(exp)
            }

            // Check limits existence
            if (max < min) {
                DIGITS[level] = DIGITS[level] + 1  // Try next number since current limits invalid
            } else {
                level = level + 1  // Go for further level checking since limits available
            }
        }

        // All checking is done, escape from the main check loop
        if (level < 1) break

        // Final check last bit of the most possible candidates
        // Update known low bit values
        Exp[level].add(Exp[level - 1], EXP[level][DIGITS[level]])
        Pow[level].add(Pow[level - 1], POW[digit + 1 - level][DIGITS[level]])

        // Loop to check all last bit of candidates
        while (DIGITS[level] < 10) {
            // Print out new disarium number
            if (Exp[level] == Pow[level]) {
                var s = ""
                for (i in DMAX...0) s = s + DIGITS[i].toString
                s = s.trimStart("0")
                if (s == "") s = "0"
                System.print(s)
                count = count + 1
                if (count == LIMIT) {
                    if (LIMIT < 20) {
                        System.print("\nFound the first %(LIMIT) Disarium numbers.")
                    } else {
                        System.print("\nFound all 20 Disarium numbers.")
                    }
                    return
                }
            }

            // Go to followed last bit candidate
            DIGITS[level] = DIGITS[level] + 1
            Exp[level].add(Exp[level], EXP[level][1])
            Pow[level].inc
        }

        // Reset to try next path
        DIGITS[level] = 0
        level = level - 1
        DIGITS[level] = DIGITS[level] + 1
    }
    System.print()
}
