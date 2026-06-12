# pretty-print a single card, interpreting the attribute values
def pp:
  [attributes, .] | transpose
  | map( values[.[0]][.[1]]|lpad(8) )
  | join(" ");

# Pretty-print up to 1000 trios
def findSets:
  [combinations(3) | select(isSet)] as $sets
  |  "Sets present: \($sets|length)",
     ($sets[:1000][] | (.[] | pp), ""),
     if ($sets|length) > 1000 then "... etc ..." else empty end ;

def task:
  def prompt: "Enter number of cards to deal: 3 to 81, or q to quit: ";

  createDeck(number_of_values)
  | shuffle # shuffle for each deal
  | . as $pack
  | prompt,
    (try input catch halt
     | if . == "q" then halt end
     | try tonumber catch halt
     | if . < 3 then task
       else $pack[0: 1 + tonumber]
       | findSets
       end),
    task;
