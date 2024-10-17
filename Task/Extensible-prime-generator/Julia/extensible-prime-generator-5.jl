using Printf: @printf
@time let sm = 0
          for p in PrimesPaged()
              p > 2000000 && break
              sm += p
          end; @printf("%d\n", sm) end
