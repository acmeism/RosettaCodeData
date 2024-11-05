# compare/0 compares the first two items if they are numbers,
# otherwise an "uncomparable" message is emitted.

def compare:
  def english:
    if .[0] < .[1] then "less than"
    elif .[0] == .[1] then "equal to"
    else "greater than"      # i.e .[0] > .[1]
    end;
  if (.[0]|type) == "number" and (.[1]|type) == "number" then
        "\(.[0]) is \(english) \(.[1])"
  else
       "\(.[0]) is uncomparable to \(.[1])"
  end ;

compare
