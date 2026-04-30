Red [ "Compare length of two strings" ]

s1: "Apple"
s2: "Strawberry"
print either (length? s1) > (length? s2) [[s1 s2]][[s2 s1]]
list: ["abcd" "123456789" "abcdef" "1234567"]
print sort/compare list func [a b][(length? a) > (length? b)]
