  if (n == 12) "twelve" else "not twelve"

  today match {
    case Monday =>
      Compute_Starting_Balance;
    case Friday =>
      Compute_Ending_Balance;
    case Tuesday =>
      Accumulate_Sales
    case _ => {}
  }
