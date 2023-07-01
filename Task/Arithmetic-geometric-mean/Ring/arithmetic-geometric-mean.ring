decimals(9)
see agm(1, 1/sqrt(2)) + nl
see agm(1,1/pow(2,0.5)) + nl

func agm agm,g
       while agm
             an  = (agm + g)/2
             gn  = sqrt(agm*g)
             if fabs(agm-g) <= fabs(an-gn) exit ok
             agm = an
             g   = gn
       end
       return gn
