fun calcEToEps() =
  let
    val eps = 1.0e~15
    fun calcToEps'(eest: real, prev: real, denom, i) =
      if Real.abs(eest - prev) < eps then
        eest
      else
        let
          val denom' = denom * i;
          val prev' = eest
        in
          calcToEps'(eest + 1.0/denom', prev', denom', i + 1.0)
        end
  in
    calcToEps'(2.0, 1.0, 1.0, 2.0)
  end;
