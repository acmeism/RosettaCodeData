using Printf: @printf
@time let sm = 0
          for p in Iterators.filter(isprime, Iterators.countfrom(UInt64(2)))
              p > 2000000 && break
              sm += p
          end; @printf("%d\n", sm) end
