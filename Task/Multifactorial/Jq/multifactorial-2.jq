# Print out a d-by-n table of multifactorials neatly:
def table(d; n):
  def lpad(i): tostring | (i - length) * " " + .;
  def pp(stream): reduce stream as $i (""; . + ($i | lpad(8)));

  range(1; d+1) as $d | "Degree \($d): \( pp(range(1; n+1) | multifactorial($d)) )";
