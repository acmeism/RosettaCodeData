# Project : Last letter-first letter
# Date    : 2017/12/30
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

ready = []
names = ["audino", "bagon", "baltoy", "banette",
               "bidoof", "braviary", "bronzor", "carracosta", "charmeleon",
               "cresselia", "croagunk", "darmanitan", "deino", "emboar",
               "emolga", "exeggcute", "gabite", "girafarig", "gulpin",
               "haxorus", "heatmor", "heatran", "ivysaur", "jellicent",
               "jumpluff", "kangaskhan", "kricketune", "landorus", "ledyba",
               "loudred", "lumineon", "lunatone", "machamp", "magnezone",
               "mamoswine", "nosepass", "petilil", "pidgeotto", "pikachu",
               "pinsir", "poliwrath", "poochyena", "porygon2", "porygonz",
               "registeel", "relicanth", "remoraid", "rufflet", "sableye",
               "scolipede", "scrafty", "seaking", "sealeo", "silcoon",
               "simisear", "snivy", "snorlax", "spoink", "starly", "tirtouga",
               "trapinch", "treecko", "tyrogue", "vigoroth", "vulpix",
               "wailord", "wartortle", "whismur", "wingull", "yamask"]
strbegin = "gabite"
strdir = "first"
nr = 1
add(ready,strbegin)
see strbegin + nl
while true
          if strdir = "first"
             strc = right(strbegin, 1)
             flag = 1
             nr = nr + 1
             if nr <= len(names)
                if left(names[nr],1) = strc
                   for n = 1 to len(ready)
                         if names[nr] = ready[n]
                            flag = 0
                         ok
                   next
                   if flag = 1
                      add(ready,names[nr])
                      see names[nr] + nl
                      strbegin = names[nr]
                      nr = 0
                      strdir = "last"
                      loop
                   ok
                ok
              ok
          else
             strc = right(strbegin, 1)
             flag = 1
             nr = nr + 1
             if nr <= len(names)
                if left(names[nr],1) = strc
                   for n = 1 to len(ready)
                         if names[nr] = ready[n]
                            flag = 0
                         ok
                   next
                   if flag = 1
                      add(ready,names[nr])
                      see names[nr] + nl
                      strbegin = names[nr]
                      nr = 0
                      strdir = "first"
                      loop
                   ok
                ok
             ok
          ok
end
