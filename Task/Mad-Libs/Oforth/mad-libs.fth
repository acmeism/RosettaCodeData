: madlibs
| story i word |

   "" while(System.Console askln dup notEmpty) [ + ] drop ->story

   while(story indexOf('<') dup ->i notNull) [
      story extract(i, story indexOfFrom('>', i)) ->word
      story replaceAll(word, "Word for" . word . System.Console askln) ->story
      ]	

   "Your story :" . story println ;
