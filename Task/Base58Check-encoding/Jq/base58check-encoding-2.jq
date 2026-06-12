# The base58check alphabet, i.e. 0 => "1", etc
def alphabet: "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

# input: a string in the specified $base
def convertToBase58($base):
  . as $hash
  | {x: (if $base == 16 and ($hash|startswith("0x"))
        then $hash[2:]|frombase(16)
        else $hash|frombase($base)
        end),
     sb: [] }
    | until (.x <= 0;
        (.x % 58) as $r
        | .sb += [alphabet[$r:$r+1]]
        | .x |= (. - $r) / 58 )
    | .sb | reverse | join("");

def hashes: [
    "0x61",
    "0x626262",
    "0x636363",
    "0x73696d706c792061206c6f6e6720737472696e67",
    "0x516b6fcd0f",
    "0xbf4f89001e670274dd",
    "0x572e4794",
    "0xecac89cad93923c02321",
    "0x10c8511e"
];

def task:
  def s: "25420294593250030202636073700053352635053786165627414518";

  (s | "\(lpad(58))-> \(convertToBase58(10))" ),
   (hashes[]
    | [lpad(58), convertToBase58(16)] | join("-> ") ) ;

task
