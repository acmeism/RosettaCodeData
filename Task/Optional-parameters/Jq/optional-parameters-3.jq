def sorter(options):
   sort_table( if (options|has("ordering")) then options.ordering
               else less_than_or_equal
               end;
               options.column or 0;
               options.reverse or false );

# If jq > 1.4 is being used, we may also define:
def sorter: sorter({});
