require 'prime'

RE = /123/
puts Prime.each(100_000).select {|prime| RE.match? prime.to_s}.join(" "), ""
puts "#{Prime.each(1_000_000).count {|prime| RE.match? prime.to_s} } 123-primes below 1 million."
