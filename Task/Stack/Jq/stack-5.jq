# Input: an object
# Output: the updated object with .emit filled in from `update|emit`.
# `emit` may produce a stream of values, which need not be strings.
def observe(update; emit):
  def s(stream): reduce stream as $_ (null;
    if $_ == null then .
    elif . == null then "\($_)"
    else . + "\n\($_)"
    end);
  .emit as $x
  | update
  | .emit = s($x // null, emit);
