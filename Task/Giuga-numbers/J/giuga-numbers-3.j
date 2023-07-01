divisors=: [: /:~@, */&>@{@((^ i.@>:)&.>/)@q:~&__

giuga=: {{
  r=. i.0
  p=. (2) 0 1} s=. 1r2,}.(2>.y-1+t=.1)$0
  while. t do.
    p=. p t}~ 4 p:t{p
    s=. s t}~ (s{~t-1)+1%t{p
    if. (1=t{s) +. 1 >: (t{s)+(y-t+1)%t{p do.
      t=. t-1
    elseif. t<y-3 do.
      p=. p (t+1)}~ (p{~t) >. (%-.)s{~t
      t=. t+1
    else.
      'c d'=. 2 x: s{~y-3
      dc=. d-c
      k=. (d^2)-dc
      for_h. ({.~ <.@-:@>:@#) f=. divisors k do.
        if. 0=dc|h+d do.
          if. 0=dc|dkh=. d+k%h do.
            py3=. p{~y-3
            if. py3 < r1=. (h+d)%dc do.
              if. py3 < r2=. dkh%dc do.
                if. r1~:r2 do.
                  if. 1 p: r1 do.
                    if. 1 p: r2 do.
                      r=. r, d*r1*r2
                    end.
                  end.
                end.
              end.
            end.
          end.
        end.
      end.
    end.
  end.
  r
}}
