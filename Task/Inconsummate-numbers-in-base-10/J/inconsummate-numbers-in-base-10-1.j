dsum=:  [: +/"(1) 10&#.inv NB. digital sum
incons=: (-. (% dsum))&(1+i.) (90* 10 >.&.^. ]) NB. exclude many digital sum ratios
