let val inf = 1.0/0.0
    val ninf = ~1.0/0.0
    val nzero = ~0.0
    val nan = 0.0/0.0
    fun f (s, x) = print (s ^ " \t= " ^ Real.toString x ^ "\n")
    fun g (s, x) = print (s ^ " \t= " ^ Bool.toString x ^ "\n")
in app f [("positive infinity", inf),
          ("negative infinity", ninf),
          ("negative zero", nzero),
          ("not a number", nan),
          ("+inf + 2.0", inf + 2.0),
          ("+inf - 10.1", inf - 10.1),
          ("+inf + -inf", inf + ninf),
          ("0.0 * +inf", 0.0 * inf),
          ("1.0/-0.0", 1.0 / nzero),
          ("NaN + 1.0", nan + 1.0),
          ("NaN + NaN", nan + nan)];
   app g [("NaN == NaN", Real.==(nan, nan)),
          ("0.0 == -0.0", Real.==(0.0, nzero))]
end
