# hex of a number or a single (unicode) character
def hex:
  def stream:
    recurse(if . >= 16 then ./16|floor else empty end) | . % 16 ;
  if type=="string" then explode[0] else . end
  | [stream] | reverse
  |  map(if . < 10 then 48 + . else . + 87 end) | implode ;

def lpad($len): tostring | " " * ($len - width) + .;

def q: "«\(.)»";

def header:
  "\("string"|q|lpad(38)) :  |s| : C : hex  IO=0";

def data:
 "",
 ".",
 "abcABC",
 "XYZ ZYX",
 "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ",
 "😍😀🙌💃😍🙌" ;
