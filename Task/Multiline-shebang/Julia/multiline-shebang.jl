#!/bin/sh
#=
  echo Julia will ignore as commented all text between #= and =#
  echo which allows us to place arbitrary unix shell code here
  echo perhaps to change environment settings for Julia or
  echo set the directory prior to starting the Julia program.
  echo for example:
  cd /user/meeting/working
  echo then start the Julia program
  exec julia "$0" "$@"
#  comments ignored by Julia end here --> =#

function countto(n)
    i = zero(n)
    println("Counting to $n...")
    while i < n
        i += 1
    end
    println("Done!")
end

@time countto(10^10)
