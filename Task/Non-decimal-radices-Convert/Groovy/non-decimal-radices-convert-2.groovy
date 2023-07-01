def numString = '101'
(2..Character.MAX_RADIX).each { radix ->
    def value = radixParse(numString, radix)
    assert value == radix**2 + 1
    printf ("         %3s (%2d) == %4d (10)\n", numString, radix, value)

    def valM2str = radixFormat(value - 2, radix)
    def biggestDigit = radixFormat(radix - 1, radix)
    assert valM2str == biggestDigit + biggestDigit
    printf ("%3s (%2d) - 2 (10) == %4s (%2d)\n", numString, radix, valM2str, radix)
}
