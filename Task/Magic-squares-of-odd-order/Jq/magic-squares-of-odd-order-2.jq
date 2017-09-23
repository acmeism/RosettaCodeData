def task:
  def pp: if length == 0 then empty
          else "\(.[0])", (.[1:] | pp )
          end;
  "The magic sum for a square of size \(.) is \( (.*. + 1)*./2 ):",
    (odd_magic_square | pp)
;

(3, 5, 9) | task
