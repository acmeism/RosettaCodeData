type Days is (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday);
Today : Days;

case Today is
  when Saturday | Sunday =>
     null;
  when Monday =>
     Compute_Starting_Balance;
  when Friday =>
     Compute_Ending_Balance;
  when others =>
     Accumulate_Sales;
end case;
