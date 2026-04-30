Rebol [
    title: "Rosetta code: Bitcoin_address_validation"
    file:  %Bitcoin_address_validation.r3
    url:   https://rosettacode.org/wiki/Bitcoin/address_validation
]

decode-base58: function [
    "Decodes a Base58-encoded string into a 25-byte binary value."
    input [string!]
][
    size: 25
    alphabet: "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    result: make binary! size
    append/dup result 0 size
    foreach c input [
        ;; Find character position (1-based). Returns none if not in alphabet.
        i: index? find/case alphabet c
        unless i [return none]                  ;; Invalid character found
        i: i - 1                                ;; Convert to 0-based index
        ;; Treat result as a base-256 big-endian number and multiply by 58,
        ;; adding the new digit. Work right-to-left to propagate carries.
        for j size 1 -1 [
            i: i + (58 * to integer! result/:j)
            result/:j: i % 256                  ;; Store the low byte
            i: to integer! (i / 256)            ;; Carry the remainder leftward
        ]
        if i != 0 [return none] ;; Address too long
    ]
    result
]
valid-bitcoin?: function [
    "Returns true if a Bitcoin address has a valid checksum, false otherwise."
    address [string!]
][
    did all [
        bin: decode-base58 address             ;; Decode to 25 raw bytes (21 payload + 4 checksum)
        sum: checksum/part bin 'sha256 21      ;; SHA256 over the first 21 bytes (payload only)
        sum: checksum      sum 'sha256         ;; SHA256 again (double-hash)
        equal? (skip bin 21) (copy/part sum 4) ;; Compare last 4 bytes of address to first 4 of hash
    ]
]

foreach address [
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i" ; VALID
    "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9" ; VALID
    "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X" ; checksum changed, original data.
    "1ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i" ; data changed, original checksum.
    "1A Na15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i" ; invalid chars
][
    print [address 'is pick ["valid." "invalid!"] valid-bitcoin? address]
]
