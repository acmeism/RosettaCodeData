# Input: a JSON object representing a SLL
# Output: an object with the same value after
# removal of the first item for which (.item|f) is truthy
def remove(f):
  def r:
    if has("item") and (.item|f) then .next
    elif .next then .next |= r
    else .
    end;
  r;

# Input: a JSON entity representing a SLL.
# Output: an object with the same value after
# removal of the first occurrence of $x if any.
def remove_item($x):
  remove(. == $x);

def remove_all(f):
  def r:
    if has("item") and (.item|f) then .next | r
    elif .next then .next |= r
    else .
    end;
  r;
