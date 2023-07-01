charcols=: {{
  'one two three'=. y
  for_a. one do.
    echo a,(a_index{two),":a_index{three
  end.
}}

   charcols 'abc';'ABC';1 2 3
aA1
bB2
cC3
