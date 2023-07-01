possible=: cut;._2 'May 15, May 16, May 19, June 17, June 18, July 14, July 16, August 14, August 15, August 17,'

Albert=: {."1 NB. Albert knows month
Bernard=: {:"1 NB. Bernard knows day

NB. Bernard's understanding of Albert's first pass
  days=: {:"1 possible
  invaliddays=: (1=#/.~ days)#~.days
  months=: {."1 possible
  validmonths=: months -. (days e. invaliddays)#months
  possibleA=. (months e. validmonths)# possible

NB. Albert's understanding of Bernard's pass
  days=: {:"1 possibleA
  invaliddays=: (1<#/.~ days)#~.days
  possibleB=. (days e. days-.invaliddays)# possibleA

NB. our understanding of Albert's understanding of Bernard's understanding of Albert's first pass
  months=: {."1 possibleB
  invalidmonths=: (1<#/.~months)#~.months
  echo ;:inv (months e. months -. invalidmonths)#possibleB
