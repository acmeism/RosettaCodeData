const
  Target = 'METHINKS IT IS LIKE A WEASEL';
  Alphabet = ' ABCDEFGHIJLKLMNOPQRSTUVWXYZ';
  P = 0.05;
  C = 100;

function negFitness(trial: string) :=
   trial.Zip(Target, (x, y) -> (if x = y then 0 else 1)).Sum;

function mutate(parent: string) :=
   parent.Aggregate('', (mut, ch) -> mut + (if Random(1.0) < P then Alphabet.RandomElement else ch));

begin
  var parent := (1..Target.Length).Aggregate('', (p, x)-> p + Alphabet.RandomElement);
  var i := 0;
  while parent <> Target do
  begin
    var copies := ArrGen(C, x -> mutate(parent));
    parent := copies.Aggregate((p, x) -> (if negFitness(x) < negFitness(p) then x else p));
    if i mod 10 = 0 then Println(i, ' ', parent);
    i += 1;
  end;
  Println(i, ' ', parent)
end.
