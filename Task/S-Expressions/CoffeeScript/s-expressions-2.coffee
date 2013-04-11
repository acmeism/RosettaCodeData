> coffee sexp.coffee
input:
((data "quoted data with escaped \"" 123 4.5 "14")
 (data (!@# (4.5) "(more" "data)")))

output:
[
  [
    "data",
    "quoted data with escaped \"",
    123,
    4.5,
    "14"
  ],
  [
    "data",
    [
      "!@#",
      [
        4.5
      ],
      "(more",
      "data)"
    ]
  ]
]

round trip:
(("data" "quoted data with escaped \"" 123 4.5 "14") ("data" ("!@#" (4.5) "(more" "data)")))
