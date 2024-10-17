procedure Check(Condition1: Boolean; Condition2: Boolean)
begin
  if (Condition1 = True) and (Condition2 = True) then
    BothConditionsAreTrue
  else if Condition1 = True then
    FirstConditionIsTrue
  else if Condition2 = True then
    SecondConditionIsTrue
  else NoConditionIsTrue;
end;
