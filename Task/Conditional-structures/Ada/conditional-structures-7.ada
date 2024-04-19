case Today is
  when Saturday | Sunday =>
     null; -- don't do anything, if Today is Saturday or Sunday
  when Monday =>
     Compute_Starting_Balance;
  when Friday =>
     Compute_Ending_Balance;
  when Tuesday .. Thursday =>
     Accumulate_Sales;
end case;
