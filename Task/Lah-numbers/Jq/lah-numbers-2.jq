def printlahtable($kmax):
  def pad: lpad(12);
  reduce range(0;$kmax+1) as $k ("n/k"|lpad(4); . + ($k|pad)),
  (range(0; $kmax+1) as $n
   | reduce range(0;$n+1) as $k ($n|lpad(4);
       . + (lah($n; $k) | pad)) ) ;

def task:
 "Unsigned Lah numbers up to n==12",
 printlahtable(12), "",
 "The maxiumum of lah(100, _) is: \(max( lah(100; range(0;101)) ))"
 ;

task
