def sort_by_decorator(decorator):
  map([decorator, .])  # decorate
  | sort_by(.[0])      # sort by decorator
  | map(.[1])          # undecorate
  ;

# Illustration
["Rosetta", "Code", "is", "a", "programming", "chrestomathy", "site"]
| sort_by(length), sort_by_decorator(length)
