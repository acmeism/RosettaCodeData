include std/console.e -- for display
include std/sequence.e -- for flatten
sequence s = flatten(repeat("ha",5))
display(s)
