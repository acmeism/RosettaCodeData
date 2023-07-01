import arraymancer, arraymancer/linear_algebra

var m = [[3, 0], [4, 5]].toTensor().asType(float)
let (u, s, vt) = m.svd()

# With "$", floats are displayed with 6 digits.
# So we use "pretty" to display 8 digits.

echo "U:"
echo u.pretty(8), '\n'

echo "Σ:"
echo s.pretty(8), '\n'

echo "V:"
echo vt.transpose().pretty(8)
