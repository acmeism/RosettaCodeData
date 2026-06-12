def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def hex_stream:
  recurse(if . >= 16 then ./16|floor else empty end) | . % 16 ;

# Emit a stream of the decimal integers in range(1; $upper+1) satisfying the condition
def no_hex_digits($upper):
  range(1; $upper)
  | select( all(hex_stream; . > 9) );

[no_hex_digits(500)]
| (_nwise(14) | map(lpad(3)) | join(" ")),
  "\n\(length) such numbers found."
