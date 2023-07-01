# requires jq version > 1.4
def simulate(stream):
  foreach stream as $observation
    (initial_state;
     update_state($observation);
     standard_deviation);
