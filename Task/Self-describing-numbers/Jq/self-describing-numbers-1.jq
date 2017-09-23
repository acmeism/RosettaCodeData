# If your jq includes all/2 then comment out the following definition,
# which is slightly less efficient:
def all(generator; condition):
  reduce generator as $i (true; if . then $i | condition else . end);
