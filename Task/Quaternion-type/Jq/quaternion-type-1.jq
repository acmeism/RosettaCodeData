def Quaternion(q0;q1;q2;q3): { "q0": q0, "q1": q1, "q2": q2, "q3": q3, "type": "Quaternion" };

# promotion of a real number to a quaternion
def Quaternion(r): if (r|type) == "number" then Quaternion(r;0;0;0) else r end;

# thoroughly recursive pretty-print
def pp:

  def signage: if . >= 0 then "+ \(.)" else  "- \(-.)" end;

  if type == "object" then
     if .type == "Quaternion" then
       "\(.q0) \(.q1|signage)i \(.q2|signage)j \(.q3|signage)k"
     else with_entries( {key, "value" : (.value|pp)} )
     end
  elif type == "array" then map(pp)
  else .
  end ;

def real(z): Quaternion(z).q0;

# Note: imag(z) returns the "i" component only,
# reflecting the embedding of the complex numbers within the quaternions:
def imag(z): Quaternion(z).q1;

def conj(z): Quaternion(z) | Quaternion(.q0; -(.q1); -(.q2); -(.q3));

def abs2(z): Quaternion(z) | .q0 * .q0 + .q1*.q1 + .q2*.q2 + .q3*.q3;

def abs(z): abs2(z) | sqrt;

def negate(z): Quaternion(z) | Quaternion(-.q0; -.q1; -.q2; -.q3);

# z + w
def plus(z; w):
  def plusq(z;w): Quaternion(z.q0 + w.q0; z.q1 + w.q1;
                             z.q2 + w.q2; z.q3 + w.q3);
  plusq( Quaternion(z); Quaternion(w) );

# z - w
def minus(z; w):
  def minusq(z;w): Quaternion(z.q0 - w.q0; z.q1 - w.q1;
                              z.q2 - w.q2; z.q3 - w.q3);
  minusq( Quaternion(z); Quaternion(w) );

# *
def times(z; w):
  def timesq(z; w):
       Quaternion(z.q0*w.q0 - z.q1*w.q1 - z.q2*w.q2 - z.q3*w.q3;
                  z.q0*w.q1 + z.q1*w.q0 + z.q2*w.q3 - z.q3*w.q2;
                  z.q0*w.q2 - z.q1*w.q3 + z.q2*w.q0 + z.q3*w.q1;
                  z.q0*w.q3 + z.q1*w.q2 - z.q2*w.q1 + z.q3*w.q0);
  timesq( Quaternion(z); Quaternion(w) );

# (z/w)
def div(z; w):
  if (w|type) == "number" then Quaternion(z.q0/w; z.q1/w; z.q2/w; z.q3/w)
  else times(z; inv(w))
  end;

def inv(z): div(conj(z); abs2(z));


# Example usage and output:

def say(msg; e): "\(msg) => \(e|pp)";

def demo:
  say( "Quaternion(1;0;0;0)"; Quaternion(1;0;0;0)),
  (Quaternion (1; 2; 3; 4) as $q
  | Quaternion(2; 3; 4; 5) as $q1
  | Quaternion(3; 4; 5; 6) as $q2
  | 7 as $r
  | say( "abs($q)";        abs($q) ),   # norm
    say( "negate($q)";     negate($q) ),
    say( "conj($q)";       conj($q) ),
    "",
    say( "plus($r; $q)";   plus($r; $q)),
    say( "plus($q; $r)";   plus($q; $r)),
    "",
    say( "plus($q1; $q2 )"; plus($q1; $q2)),
    "",
    say( "times($r;$q)";    times($r;$q)),
    say( "times($q;$r)";    times($q;$r)),
    "",
    say( "times($q1;$q2)";  times($q1;$q2)),
    say( "times($q2; $q1)"; times($q2; $q1)),
    say( "times($q1; $q2) != times($q2; $q1)";
         times($q1; $q2) != times($q2; $q1) )
    ) ;

demo
