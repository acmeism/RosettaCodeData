(* https://www.cs.ox.ac.uk/people/jeremy.gibbons/publications/spigot.pdf *)

fun gibbons _ _ _ _ _ _ 0 = ()
  | gibbons q r t k n l count =
  let
    val (q',r',t',k',n',l',count') =
      if 4*q+r-t < n*t
      then (10*q,10*(r-n*t),t,k,(10*(3*q+r)) div t-10*n,l,count-1) before print (IntInf.toString n)
      else (q*k,(2*q+r)*l,t*l,k+1,(q*(7*k+2)+r*l) div (t*l),l+2,count)
  in
    gibbons q' r' t' k' n' l' count'
  end

fun doGibbons n = gibbons 1 0 1 1 3 3 n

fun timeGibbons n =
  let
    val timer1 = Timer.startCPUTimer ()
    val () = doGibbons n
    val {usr=usr, sys=sys} = Timer.checkCPUTimer timer1
  in
    print "\n----------------------\n";
    print ("usr: " ^ Time.toString usr ^ "\n");
    print ("sys: " ^ Time.toString sys ^ "\n")
  end

fun main () = timeGibbons 5000
