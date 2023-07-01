-- create the searcher and run it
searcher = .chainsearcher~new

::class chainsearcher
::method init
  expose max searchsize currentlongest

  pokemon_names = "audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon" -
                  "cresselia croagunk darmanitan deino emboar emolga exeggcute gabite" -
                  "girafarig gulpin haxorus heatmor heatran ivysaur jellicent jumpluff kangaskhan" -
                  "kricketune landorus ledyba loudred lumineon lunatone machamp magnezone mamoswine" -
                  "nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2" -
                  "porygonz registeel relicanth remoraid rufflet sableye scolipede scrafty seaking" -
                  "sealeo silcoon simisear snivy snorlax spoink starly tirtouga trapinch treecko" -
                  "tyrogue vigoroth vulpix wailord wartortle whismur wingull yamask"

  pokemon = pokemon_names~makearray(" ")
  searchsize = pokemon~items
  currentlongest = 0
  say "searching" searchsize "names..."
  longestchain = .array~new
  -- run the sequence using each possible starting pokemon
  loop i = 1 to pokemon~items
      -- swap the ith name to the front of our list
      self~swap(pokemon, 1, i)
      -- run the chain from here
      self~searchChain(pokemon, longestchain, 2)
      -- swap the name back so we have the list in original form
      self~swap(pokemon, 1, i)
  end
  say "maximum path length:" longestchain~items
  say "paths of that length:" max
  say "example path of that length:"

  loop name over longestchain
      say "    "name
  end

::method swap
  use arg list, a, b
  tmp = list[a]
  list[a] = list[b]
  list[b] = tmp

-- recursive search routine for adding to the chain
::method searchChain
  expose max searchsize currentlongest
  use arg pokemon, longestchain, currentchain

  -- get the last character
  lastchar = pokemon[currentchain - 1]~right(1)
  -- now we search through all of the permutations of remaining
  -- matches to see if we can find a longer chain
  loop i = currentchain to searchsize
      -- for every candidate name from here, recursively extend the chain.
      if pokemon[i]~left(1) == lastchar then do
          if currentchain == currentLongest then max += 1
          -- have we now gone deeper than the current longest chain?
          else if currentchain > currentLongest then do
             -- chuck this result and refill with current set
             longestchain~empty
             longestchain~appendall(pokemon~section(1, currentchain - 1))
             longestchain~append(pokemon[i])
             max = 1
             currentLongest = currentchain
          end
          -- perform the swap again
          self~swap(pokemon, currentchain, i)
          -- run the chain from here
          self~searchChain(pokemon, longestchain, currentchain + 1)
          -- swap the name back so we have the list in original form
          self~swap(pokemon, currentchain, i)
      end
  end
