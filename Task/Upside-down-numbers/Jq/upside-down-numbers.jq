# Output an unbounded stream of upside-down numbers
def genUpsideDown:
  def wrappings: [
        [1, 9], [2, 8], [3, 7], [4, 6], [5, 5],
        [6, 4], [7, 3], [8, 2], [9, 1] ];
  { evens: [19, 28, 37, 46, 55, 64, 73, 82, 91],
    odds:  [5],
    oddIndex: 0, evenIndex: 0, ndigits: 1, pow: 100 }
  | while (true;
        .emit = null
        | if .ndigits % 2 == 1
          then if (.odds|length) > .oddIndex
               then .emit = .odds[.oddIndex]
               | .oddIndex += 1
               else  # build next odds, but switch to evens
               .nextOdds = []
               | reduce wrappings[] as $w (.;
                    reduce .odds[] as $i (.;
                        .nextOdds += [$w[0] * .pow + $i * 10 + $w[1]] ) )
               | .odds = .nextOdds
               | .ndigits += 1
               | .pow *= 10
               | .oddIndex = 0
               end
          elif (.evens|length) > .evenIndex
          then .emit = .evens[.evenIndex]
          | .evenIndex += 1
          else # build next evens, but switch to odds
          .nextEvens = []
          | reduce wrappings[] as $w (.;
               reduce .evens[] as $i (.;
                  .nextEvens += [$w[0] * .pow + $i * 10 + $w[1]] ) )
          | .evens = .nextEvens
          | .ndigits += 1
          | .pow *= 10
          | .evenIndex = 0
          end )
  | select(.emit).emit ;

def task($limit):
  { count:0, ud50s: [], pow: 50 }
  | foreach limit($limit; genUpsideDown) as $n (.;
      .emit = null
      | .count +=  1
      | if .count < 50
        then .ud50s += [$n]
        elif .count == 50
        then .emit = {"First 50 upside down numbers:": (.ud50s + [$n]) }
        | .pow = 500
        elif .count == .pow
        then .emit = {pow, $n}
        | .pow *= 10
        else .
        end)
  | select(.emit).emit;

task(5000000)
