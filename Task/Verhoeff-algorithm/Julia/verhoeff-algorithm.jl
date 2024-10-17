const multiplicationtable = [
    0  1  2  3  4  5  6  7  8  9;
    1  2  3  4  0  6  7  8  9  5;
    2  3  4  0  1  7  8  9  5  6;
    3  4  0  1  2  8  9  5  6  7;
    4  0  1  2  3  9  5  6  7  8;
    5  9  8  7  6  0  4  3  2  1;
    6  5  9  8  7  1  0  4  3  2;
    7  6  5  9  8  2  1  0  4  3;
    8  7  6  5  9  3  2  1  0  4;
    9  8  7  6  5  4  3  2  1  0]

const permutationtable = [
    0  1  2  3  4  5  6  7  8  9;
    1  5  7  6  2  8  3  0  9  4;
    5  8  0  3  7  9  6  1  4  2;
    8  9  1  6  0  4  3  5  2  7;
    9  4  5  3  1  2  6  8  7  0;
    4  2  8  6  5  7  3  9  0  1;
    2  7  9  3  8  0  6  4  1  5;
    7  0  4  6  9  1  3  2  5  8]

const inv = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9]

"""
    verhoeffchecksum(n::Integer, validate=true, terse=true, verbose=false)

Calculate the Verhoeff checksum over `n`.
Terse mode or with single argument: return true if valid (last digit is a correct check digit).
If checksum mode, return the expected correct checksum digit.
If validation mode, return true if last digit checks correctly.
"""
function verhoeffchecksum(n::Integer, validate=true, terse=true, verbose=false)
    verbose && println("\n", validate ? "Validation" : "Check digit",
        " calculations for '$n':\n\n", " i  nᵢ  p[i,nᵢ]  c\n------------------")
    # transform number list
    c, dig = 0, reverse(digits(validate ? n : 10 * n))
    for i in length(dig):-1:1
        ni = dig[i]
        p = permutationtable[(length(dig) - i) % 8 + 1, ni + 1]
        c = multiplicationtable[c + 1, p + 1]
        verbose && println(lpad(length(dig) - i, 2), "  $ni      $p    $c")
    end
    verbose && !validate && println("\ninv($c) = $(inv[c + 1])")
    !terse && println(validate ? "\nThe validation for '$n' is $(c == 0 ?
        "correct" : "incorrect")." : "\nThe check digit for '$n' is $(inv[c + 1]).")
    return validate ? c == 0 : inv[c + 1]
end

for args in [(236, false, false, true), (2363, true, false, true), (2369, true, false, true),
    (12345, false, false, true), (123451, true, false, true), (123459, true, false, true),
    (123456789012, false, false), (1234567890120, true, false), (1234567890129, true, false)]
        verhoeffchecksum(args...)
end
