Rebol [
    title: "Rosetta code: Palindromic primes in base 16"
    file:  %Palindromic_primes_in_base_16.r3
    url:   https://rosettacode.org/wiki/Palindromic_primes_in_base_16
]

hexadecimal-palindrome?: function [
    "Return the hex string if n is a prime hexadecimal palindrome, else none."
    n [integer!]
][
    all [
        prime? n
        parse enbase n 16 [any #"0" hex: to end] ;; hex string, leading zeros stripped
        hex = reverse copy hex                   ;; palindrome check
        hex                                      ;; return the hex string (or none)
    ]
]

print collect [
    repeat i 500 [
        ;; keep hex string if palindrome prime
        if hex: hexadecimal-palindrome? i [keep hex]
    ]
]
