# Project : Aliquot sequence classnifications
# Date    : 2017/11/16
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

see "Rosetta Code - aliquot sequence classnifications" + nl
while true
        see "enter an integer: "
        give k
        k=fabs(floor(number(k)))
        if k=0
           exit
        ok
        printas(k)
end
see "program complete."

func printas(k)
       length=52
       aseq = list(length)
       n=k
       classn=0
       priorn = 0
       inc = 0
       for element=2 to length
            aseq[element]=pdtotal(n)
            see aseq[element] + " " + nl
            if aseq[element]=0
               see " terminating" + nl
               classn=1
               exit
            ok
            if aseq[element]=k and element=2
               see " perfect" + nl
               classn=2
               exit
            ok
            if aseq[element]=k and element=3
               see " amicable" + nl
               classn=3
               exit
            ok
            if aseq[element]=k and element>3
               see " sociable" + nl
               classn=4
               exit
            ok
            if aseq[element]!=k and aseq[element-1]=aseq[element]
               see " aspiring" + nl
               classn=5
               exit
            ok
            if aseq[element]!=k and element>2 and aseq[element-2]= aseq[element]
               see " cyclic" + nl
               classn=6
              exit
            ok
            n=aseq[element]
            if n>priorn
               priorn=n
               inc=inc+1
            but n<=priorn
                  inc=0
                  priorn=0
            ok
            if inc=11 or n>30000000
               exit
            ok
       next
       if classn=0
          see " non-terminating" + nl
       ok

func pdtotal(n)
       pdtotal = 0
       for y=2 to n
           if (n % y)=0
               pdtotal=pdtotal+(n/y)
           ok
       next
       return pdtotal
