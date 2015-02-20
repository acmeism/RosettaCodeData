/* Weasel.rex - Me thinks thou art a weasel. - G,M.D. - 2/25/2011 */
arg C M
/* C is the number of children parent produces each generation. */
/* M is the mutation rate of each gene (character) */

call initialize
generation = 0
do until parent = target
   most_fitness = fitness(parent)
   most_fit     = parent
   do C
      child = mutate(parent, M)
      child_fitness = fitness(child)
      if child_fitness > most_fitness then
      do
         most_fitness = child_fitness
         most_fit = child
         say "Generation" generation": most fit='"most_fit"', fitness="left(most_fitness,4)
      end
   end
   parent = most_fit
   generation = generation + 1
end
exit

initialize:
   target   = "METHINKS IT IS LIKE A WEASEL"
   alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
   c_length_target = length(target)
   parent  = mutate(copies(" ", c_length_target), 1.0)
   do i = 1 to c_length_target
      target_ch.i = substr(target,i,1)
   end
return

fitness: procedure expose target_ch. c_length_target
   arg parm_string
   fitness = 0
   do i_target = 1 to c_length_target
      if substr(parm_string,i_target,1) = target_ch.i_target then
         fitness = fitness + 1
   end
return fitness

mutate:procedure expose alphabet
arg string, parm_mutation_rate
   result = ""
   do istr = 1 to length(string)
      if random(1,1000)/1000 <= parm_mutation_rate then
         result = result || substr(alphabet,random(1,length(alphabet)),1)
      else
         result = result || substr(string,istr,1)
   end
return result
