# Input is the string to be encoded, st is the initial symbol table (an array)
# Output: the encoded string (an array)
def m2f_encode(st):
  reduce explode[] as $ch
    ( [ [], st];                  # state: [ans, st]
      (.[1]|index($ch)) as $ix
      | .[1] as $st
      | [ (.[0] + [ $ix ]),  [$st[$ix]] + $st[0:$ix] + $st[$ix+1:] ] )
  | .[0];

# Input should be the encoded string (an array)
# and st should be the initial symbol table (an array)
def m2f_decode(st):
  reduce .[] as $ix
    ( [ [], st];                  # state: [ans, st]
      .[1] as $st
      | [ (.[0] + [ $st[$ix] ]),  [$st[$ix]] + $st[0:$ix] + $st[$ix+1:] ] )
  | .[0]
  | implode;
