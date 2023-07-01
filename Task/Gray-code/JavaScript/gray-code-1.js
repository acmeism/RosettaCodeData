export function encode (number) {
    return number ^ (number >> 1)
}

export function decode (encodedNumber) {
    let number = encodedNumber

    while (encodedNumber >>= 1) {
        number ^= encodedNumber
    }

    return number
}
