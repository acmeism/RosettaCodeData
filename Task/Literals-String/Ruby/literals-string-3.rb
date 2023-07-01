print <<HERE
With an unquoted delimiter, this interpolates:
a = #{a}
HERE
print <<-INDENTED
   This delimiter can have whitespace before it
   INDENTED
print <<'NON_INTERPOLATING'
This will not interpolate: #{a}
NON_INTERPOLATING
