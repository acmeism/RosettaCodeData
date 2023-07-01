$string = 'ouch';
$bits = chop($string);       # The last letter is returned by the chop function
print $bits;        # h
print $string;      # ouc    # See we really did chop the last letter off
