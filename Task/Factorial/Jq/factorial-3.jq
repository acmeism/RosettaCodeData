def fact:
  def _fact:
    # Input: [accumulator, counter]
    if .[1] <= 1 then .
    else [.[0] * .[1], .[1] - 1]|  _fact
    end;
  # Extract the accumulated value from the output of _fact:
  [1, .] | _fact | .[0] ;
