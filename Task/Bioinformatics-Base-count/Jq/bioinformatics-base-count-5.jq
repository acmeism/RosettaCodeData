def lpad($len; $fill): tostring | ($len - length) as $l | ($fill * $l)[:$l] + .;

# "bow" = bag of words, i.e. a JSON object with counts
# Input: a bow or null
# Output: augmented bow
def bow(stream):
  reduce stream as $word (.; .[($word|tostring)] += 1);

# The main function ignores its input in favor of `stream`:
def report(stream; $cols):

  # input: a string, possibly longer than $cols
  def pp_sequence($start):
  range(0; length / $cols) as $i
    | "\($start + ($i*$cols) | lpad(5; " ")): " +  .[ $i * $cols : ($i+1) * $cols] ;

  # input: a bow
  def pp_counts:
    "BASE COUNTS:",
     (to_entries | sort[] | "    \(.key):  \(.value | lpad(6;" "))"),
     "Total: \( [.[]] | add | lpad(7;" "))" ;

  # state: {bow, emit, pending, start}
  foreach (stream,null) as $line ({start: - $cols};
    .start += $cols
    | if $line == null
      then .emit = .pending
      else .bow |= bow(range(0; $line|length) | $line[.:.+1])
      | (($line|length) + (.pending|length) ) as $len
      | if $len >= $cols
        then (.pending + $line) as $new
        | .emit = $new[:$cols]
        | .pending = $new[$cols:]
        else .pending = $line
        end
      end;
    (select(.emit|length > 0) | .start as $start | .emit | pp_sequence($start)),
    (select($line == null) | "", (.bow|pp_counts) ) )
    ;

# To illustrate reformatting:
report(inputs; 33)
