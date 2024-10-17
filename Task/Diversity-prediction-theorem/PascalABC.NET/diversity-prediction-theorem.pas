##
function AverageSquareDiff(a: real; predictions: array of real) :=
   predictions.Select(x -> (x - a).Sqr).Average;

procedure DiversityTheorem(truth: real; predictions: array of real);
begin
  var average := predictions.Average;
  WriteLn('average-error: ', AverageSquareDiff(truth, predictions));
  WriteLn('crowd-error:   ', (truth - average).Sqr);
  WriteLn('diversity:     ', AverageSquareDiff(average, predictions));
end;

DiversityTheorem(49.0, |48.0, 47.0, 51.0|);
DiversityTheorem(49.0, |48.0, 47.0, 51.0, 42.0|)
