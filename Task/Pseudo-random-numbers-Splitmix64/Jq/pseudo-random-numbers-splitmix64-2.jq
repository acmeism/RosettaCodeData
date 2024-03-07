# input: a bitarray
def nextInt:
  def Const1: "9e3779b97f4a7c15" | frombase(16) ;
  def Const2: "bf58476d1ce4e5b9" | frombase(16) ;
  def Const3: "94d049bb133111eb" | frombase(16) ;

  (plus(Const1) | mask64)
  | . as $state
  |  xor(.; right(30)) | mult(Const2) | mask64
  |  xor(.; right(27)) | mult(Const3) | mask64
  |  xor(.; right(31)) | mask64
  | ., ($state|nextInt) ;

def randomInt64: [bitwise] | nextInt | to_int;

def randomReal:
  pow(2;64) as $d
  | [bitwise] | nextInt | to_int / $d;

### The tasks
(limit(5; 1234567 | randomInt64)),

"\nThe counts for 100,000 repetitions are:",
tabulate( limit(100;  987654321 | randomReal * 5 | floor) )
