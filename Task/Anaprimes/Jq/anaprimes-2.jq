# Input: null or a suitable array of primes
# Output: for each maximally sized group: [number, min, max]
def anaprimes($limit):

  def stats:
     maximals_by(.[]; length)
     | [length, min, max];

  def groupOf: tostring | explode | sort | implode;

  (if . then . else $limit|primes end) as $primes
  | reduce $primes[] as $p ({}; .[$p|groupOf] += [$p])
  | stats;

def task($digits):
  # Avoid recomputing the primes array:
  (pow(10;$digits) | primes) as $primes
  | range(3; $digits+1) as $i
  | pow(10; $i) as $p
  | "For \($i) digit numbers:",
     ($primes | map(select(.<$p)) | anaprimes($p)),
    "";

task(7)
