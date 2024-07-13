include "bitwise" {search: "."};  # see above

# non-negative decimal integer to hex string
def hex:
  def stream:
    recurse(if . >= 16 then ./16|floor else empty end) | . % 16 ;
  [stream] | reverse
  |  map(if . < 10 then 48 + . else . + 87 end) | implode ;

### CRC-32

def crc32Table:
  reduce range(0; 256) as $i ([];
    . + [reduce range(0; 8) as $j ($i;
              if bitwise_and(.;1) == 1
              then bitwise_xor(rightshift(1); 3988292384) # 0xedb88320
              else rightshift( 1 )
              end) ] );

# Input: an ASCII string
# Output: its CRC-32
def crc32:
  explode as $s
  | crc32Table as $table
  | reduce range(0; $s|length) as $i (4294967295 ; # ~0
      # 0xff is 255
      bitwise_and(.; 255 ) as $crb
      | bitwise_xor( $table[bitwise_xor($crb; $s[$i])] ; rightshift(8)) )
  | flip(32) ;

def task:
  crc32 | hex;

"The quick brown fox jumps over the lazy dog" | task
