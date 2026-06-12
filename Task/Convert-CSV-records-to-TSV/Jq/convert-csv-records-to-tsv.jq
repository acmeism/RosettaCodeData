## The PEG * operator:
def star(E): (E | star(E)) // . ;

## Helper functions:

# Consume a regular expression rooted at the start of .remainder, or emit empty;
# on success, update .remainder and set .match but do NOT update .result
def consume($re):
  # on failure, match yields empty
  (.remainder | match("^" + $re)) as $match
  | .remainder |= .[$match.length :]
  | .match = $match.string;

def parse($re):
  consume($re)
  | .result = .result + [.match] ;

def ws: consume(" *");

### Parse a string into comma-separated values

def quoted_field_content:
  parse("((\"\")|([^\"]))*")
  | .result[-1] |= gsub("\"\""; "\"");

def unquoted_field: parse("[^,\"]*");

def quoted_field: consume("\"") | quoted_field_content | consume("\"");

def field: (ws | quoted_field | ws) // unquoted_field;

def record: field | star(consume(",") | field);

def csv2tsv:
  {remainder: .} | record | .result | @tsv ;

# Transform an entire file assuming jq is invoked with the -n option
inputs | csv2tsv
