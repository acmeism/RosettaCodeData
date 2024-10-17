type
  colors = (red, white, blue);

procedure threeWayPartition(a: array of colors; mid: colors);
begin
  var (i, j) := (0, 0);
  var k := a.High;
  while j <= k do
    if a[j] < mid then
    begin
      swap(a[i], a[j]);
      i += 1;
      j += 1;
    end
    else if a[j] > mid then
    begin
      swap(a[j], a[k]);
      k -= 1;
    end
    else j += 1;
end;

begin
  var balls: array of colors;
  repeat
    balls := ArrGen(10, i -> |red, white, blue|.randomelement);
  until balls <> balls.Sorted;

  println('Original ball order:', balls);
  threewaypartition(balls, white);
  println('Sorted ball order:  ', balls);
  assert(balls <> balls.sorted, 'Not sorted!');
end.
