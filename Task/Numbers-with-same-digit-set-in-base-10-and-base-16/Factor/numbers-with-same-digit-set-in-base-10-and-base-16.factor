USING: formatting grouping io kernel math.parser present
sequences sets ;

100,000 <iota> [ dup present swap >hex set= ] filter
10 group [ [ "%5d " printf ] each nl ] each
