# Uncomment the following line if using gojq or fq:
# def keys_unsorted: keys;

# next($action) determines the next state.
# Global: $fsm (the transition-table)
# $action specifies an action, which can be abbreviated: the first possible match is selected.
# Input: {state}
def next($action):
  ($fsm[.state] | keys_unsorted) as $keys
  | if ($action|length) == 0
    then if $keys|index("") then fsm[.state][""]
         else null
	 end
    else (first($keys[] | select( startswith($action) )) // null) as $k
    | if $k then fsm[.state][$k] else null end
    end;

def start: {"state": "ready"};

# The FSM engine - progress from state to state based on user input
def progress:

  def options: fsm[.state]|keys_unsorted;
  def prompt:
    options
    | if length == 1 and .[0]=="" then "Enter anything to proceed."
      elif .[0]|test("^[0-9]+ ") then  "options: \(.) (simulated non-deterministic transition)"
      else "options: \(.)"
      end;

  def help:
    options
    | if length == 1 and .[0]=="" then "(internal state transition awaiting your input)"
      elif .[0]|startswith("1 ") then "(simulated NDFSM awaiting your input in the form of an initial substring): \(.)"
      else
      "Make a selection by typing an initial substring of the option you wish to select: \(.)"
      end;

  start
  | label $out
  | "Initial state: \(.state)\nMake your selection (at least one letter) from these options: \(options))",
    foreach inputs as $in (.;
       .previous=.state
       | .error = null
       | if $in == "?" then .error = true #
         else next($in) as $next
         | if $next then .state=$next else .error = "try again or enter ? for help" end
	 end;
       if .error == true then help
       elif .error then .error
       elif .state == "exit" then break $out
       else
         "\(.previous) + \($in) => \(.state)",
         prompt
       end
       ) ;

progress
