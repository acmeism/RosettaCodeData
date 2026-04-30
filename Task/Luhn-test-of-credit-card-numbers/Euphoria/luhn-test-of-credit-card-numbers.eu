function luhn(sequence cc)
    integer isOdd, oddSum, evenSum, digit
    isOdd = 1
    oddSum = 0
    evenSum = 0
    for i = length(cc) to 1 by -1 do
        digit = cc[i] - '0'
        if isOdd then
            oddSum += digit
        else
            evenSum += floor(digit / 5) + remainder(2 * digit, 10)
        end if
        isOdd = not isOdd
    end for
    return not remainder(oddSum + evenSum, 10)
end function

constant cc_numbers = {
    "49927398716",
    "49927398717",
    "1234567812345678",
    "1234567812345670"
}

for i = 1 to length(cc_numbers) do
    printf(1,"%s = %d\n", {cc_numbers[i], luhn(cc_numbers[i])})
end for
