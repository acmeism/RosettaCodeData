case Today is
  when Monday =>
     Compute_Starting_Balance;
  when Friday =>
     Compute_Ending_Balance;
  when Tuesday .. Thursday =>
     Accumulate_Sales;
  -- ignore Saturday and Sunday
end case;
