# The following jq program assumes the input consists of a JSON array of objects having
# keys named "hash" and "filename".
def dictionary(stream; f; g):
  reduce stream as $x ({}; .[($x|f)] += [$x|g]);

dictionary(inputs[]; .hash; .filename)
| to_entries[].value
| select(length > 1)
| [.[]]
