# Input: [t, y, dt]
def newRK4Step(yp):
  .[0] as $t | .[1] as $y | .[2] as $dt
  | ($dt * ([$t, $y]|yp))              as $dy1
  | ($dt * ([$t+$dt/2, $y+$dy1/2]|yp)) as $dy2
  | ($dt * ([$t+$dt/2, $y+$dy2/2]|yp)) as $dy3
  | ($dt * ([$t+$dt, $y+$dy3]    |yp)) as $dy4
  | $y + ($dy1+2*($dy2+$dy3)+$dy4)/6
;


def printErr: # input: [t, y]
  def abs: if . < 0 then -. else . end;
  .[0] as $t | .[1] as $y
  | "y(\($t)) = \($y) with error: \( (($t|actual) - $y) | abs )"
;

def main(t0; y0; tFinal; dtPrint):

  def ypStep: newRK4Step(yprime) ;

  0.1 as $dtStep     # step value
  # [ t, y] is the state vector
  | [ t0, y0 ]
  | while( .[0] <= tFinal;
           .[0] as $t | .[1] as $y
	   | ($t + dtPrint) as $t1
	   | (((dtPrint/$dtStep) + 0.5) | floor) as $steps
	   | [$steps, $t, $y]  # state vector
           | until( .[0] <= 1;
	            .[0] as $steps
		    | .[1] as $t
		    | .[2] as $y
		    | [ ($steps - 1), ($t + $dtStep), ([$t, $y, $dtStep]|ypStep) ]
                  )
	   | .[1] as $t | .[2] as $y
	   | [$t1, ([ $t, $y, ($t1-$t)] | ypStep)]  # adjust step to integer time
         )
   | printErr # print results
;

# main(t0; y0; tFinal; dtPrint)
main(0; 1; 10; 1)
