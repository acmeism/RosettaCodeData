# use array of array for this
func$ hget &arr$[][] ind$ .
   for i to len arr$[][]
      if arr$[i][1] = ind$ : return arr$[i][2]
   .
	return ""
.
proc hset &arr$[][] ind$ val$ .
   for i to len arr$[][]
      if arr$[i][1] = ind$
         arr$[i][2] = val$
         return
      .
   .
   arr$[][] &= [ ind$ val$ ]
.
clothing$[][] = [ [ "type" "t-shirt" ] [ "color" "red" ] ]
clothing$[][] &= [ "size" "xl" ]
#
print hget clothing$[][] "color"
hset clothing$[][] "color" "green"
print hget clothing$[][] "color"
