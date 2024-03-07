check_valid_isbn13: function [str] [
  is_digit: charset [#"0" - #"9"]
  remove-each i str [not pick is_digit i] ; remove non-digits

  either 13 = length? str [               ; reject strings of incorrect length
    sum: 0
    repeat i 13 [
      mul: either even? i [3] [1]         ; multiplier for odd/even digits
      sum: sum + (mul * to integer! to string! pick str i)
    ]

    zero? (sum % 10)                      ; check if remainder mod 10 is zero
  ] [
    false
  ]
]

; check given examples
foreach [str] ["978-0596528126" "978-0596528120" "978-1788399081" "978-1788399083"] [
  prin str
  prin " - "
  print check_valid_isbn13 str
]
