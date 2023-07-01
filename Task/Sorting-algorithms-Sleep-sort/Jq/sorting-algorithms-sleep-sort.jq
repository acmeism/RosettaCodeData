echo '[5, 1, 3, 2, 11, 6, 4]' | jq '
def f:
  if .unsorted == [] then
    .sorted
  else
    { unsorted: [.unsorted[] | .t = .t - 1 | select(.t != 0)]
    , sorted: (.sorted + [.unsorted[] | .t = .t - 1 | select(.t == 0) | .v]) }
    | f
  end;
{unsorted: [.[] | {v: ., t: .}], sorted: []} | f | .[]
'
