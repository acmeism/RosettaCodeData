# The following is sufficiently accurate for the task:
def is_square: sqrt | . == floor;

# Emit a stream of "sub-unit squares"
def subunitSquares:
  def sub1:
    tostring | explode
    | if any(. == 48) then null
      else map(.-1) | implode | tonumber
      end;

  foreach range(1; infinite) as $i ( null;
    ($i * $i) as $sq
    | ($sq|sub1)
    | if . == null or (tostring[-1:] | IN("3", "7", "8")) then null
      elif is_square then $sq
      else null
      end;
      select(.) ) ;

11 as $count
| "The first \($count) sub-unit squares are:",
  limit($count; subunitSquares)
