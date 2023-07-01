# Output: first $n Padovans
def padovanRecur($n):
  [range(0;$n) | 1] as $p
  | if $n < 3 then $p
    else reduce range(3;$n) as $i ($p; .[$i] = .[$i-2] + .[$i-3])
    end;

# Output: first $n Padovans
def padovanFloor($n):
  { p: 1.324717957244746025960908854,
    s: 1.0453567932525329623,
    pow: 1 }
  | reduce range (1;$n) as $i ( .f = [ ((.pow/.p/.s) + 0.5)|floor];
      .f[$i] = (((.pow/.s) + 0.5)|floor)
      | .pow *= .p)
  | .f ;

# Output: a stream of the L-System Padovan strings
def padovanStrings:
  {A: "B", B: "C", C: "AB", "": "A"} as $rules
  | $rules[""]
  | while(true;
      ascii_downcase
      | gsub("a"; $rules["A"]) | gsub("b"; $rules["B"]) | gsub("c"; $rules["C"]) ) ;

# Output: a stream of the Padovan numbers using the L-System strings
def padovanNumbers:
  padovanStrings | length;

def task:
  def s1($n):
    if padovanFloor($n) == padovanRecur($n) then "give" else "do not give" end;

  def s2($n):
    if [limit($n; padovanNumbers)] == padovanRecur($n) then "give" else "do not give" end;

  "The first 20 members of the Padovan sequence:", padovanRecur(20),
  "",
  "The recurrence and floor-based functions \(s1(64)) the same results for 64 terms.",
  "",
  ([limit(10; padovanStrings)]
     | "First 10 members of the Padovan L-System:", .,
        "and their lengths:",
         map(length)),
  "",
  "The recurrence and L-system based functions \(s2(32)) the same results for 32 terms."
;

task
