fun step y' (tn,yn) dt =
    let
        val dy1 = dt * y'(tn,yn)
        val dy2 = dt * y'(tn + 0.5 * dt, yn + 0.5 * dy1)
        val dy3 = dt * y'(tn + 0.5 * dt, yn + 0.5 * dy2)
        val dy4 = dt * y'(tn + dt, yn + dy3)
    in
        (tn + dt, yn + (1.0 / 6.0) * (dy1 + 2.0*dy2 + 2.0*dy3 + dy4))
    end

(* Suggested test case *)
fun testy' (t,y) =
    t * Math.sqrt y

fun testy t =
    (1.0 / 16.0) * Math.pow(Math.pow(t,2.0) + 4.0, 2.0)

(* Test-runner that iterates the step function and prints the results. *)
fun test t0 y0 dt steps print_freq y y' =
    let
        fun loop i (tn,yn) =
            if i = steps then ()
            else
                let
                    val (t1,y1) = step y' (tn,yn) dt
                    val y1' = y tn
                    val () = if i mod print_freq = 0 then
                                 (print ("Time: " ^ Real.toString tn ^ "\n");
                                  print ("Exact: " ^ Real.toString y1' ^ "\n");
                                  print ("Approx: " ^ Real.toString yn ^ "\n");
                                  print ("Error: " ^ Real.toString (y1' - yn) ^ "\n\n"))
                             else ()
                 in
                     loop (i+1) (t1,y1)
                end
    in
        loop 0 (t0,y0)
    end

(* Run the suggested test case *)
val () = test 0.0 1.0 0.1 101 10 testy testy'
