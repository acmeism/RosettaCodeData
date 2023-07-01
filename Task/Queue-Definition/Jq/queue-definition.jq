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


def fifo: {queue: []};

# Is the input an object that represents the empty queue?
def isempty:
  type == "object"
  and (.queue | length == 0);  # so .queue == null and .queue == [] are equivalent

def push(e): .queue += [e];

def pop: if isempty then empty else .item = .queue[0] | .queue |= .[1:] end;

def pop_or_error: if isempty then error("pop_or_error") else pop end;

# Examples
# fifo | pop // "nothing" # produces the string "nothing"

fifo
| observe(push(42); "length after pushing: \(.queue | length)" )
| observe(push(43); "length after pushing: \(.queue | length)" )
| pop      # dequeue
| .emit, .item
