RE = /[[:alpha:]]+/
count =  open("135-0.txt").read.downcase.scan(RE).tally.max_by(10, &:last)
count.each{|ar| puts ar.join("->") }
