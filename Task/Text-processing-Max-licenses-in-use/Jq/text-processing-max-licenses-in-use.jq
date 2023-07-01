# Input: an array of strings
def max_licenses_in_use:
  # state: [in_use = 0, max_in_use = -1, max_in_use_at = [] ]
  reduce .[] as $line
    ([0,  -1, [] ];
     ($line|split(" ")) as $line
     | if $line[1] == "OUT" then
         .[0] += 1                          # in_use++;
         | if   .[0] > .[1]                 # (in_use > max_in_use)
           then .[1] = .[0]                 # max_in_use = in_use
             |  .[2] = [$line[3]]           # max_in_use_at = [$line[3]]
           elif .[0] == .[1]                # (in_use == max_in_use)
             then .[2] += [$line[3]]        # max_in_use_at << $line[3]
           else .
           end
       elif $line[1] == "IN" then .[0] -= 1 # in_use--
       else .
       end )
   | "Max licenses out: \(.[1]) at:\n \(.[2]|join("\n "))" ;

# The file is read in as a single string and so must be split at newlines:
split("\n") | max_licenses_in_use
