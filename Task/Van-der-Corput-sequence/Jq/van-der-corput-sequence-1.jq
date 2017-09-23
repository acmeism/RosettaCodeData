# vdc(base) converts an input decimal integer to a decimal number based on the van der
# Corput sequence using base 'base', e.g. (4 | vdc(2)) is 0.125.
#
def vdc(base):

  # The helper function converts a stream of residuals to a decimal,
  # e.g. if base is 2, then decimalize( (0,0,1) ) yields 0.125
  def decimalize(stream):
    reduce stream as $d   # state: [accumulator, power]
      ( [0, 1/base];
       .[1] as $power | [ .[0] + ($d * $power), $power / base] )
    | .[0];

  if . == 0 then 0
  else decimalize(recurse( if . == 0 then empty else ./base | floor end ) % base)
  end ;
