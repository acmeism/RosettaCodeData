| list |
list := #(1 2 3 4 20 10 9 8).
list inject: (list at: 1) into: [ :number :each |
  number max: each ]
