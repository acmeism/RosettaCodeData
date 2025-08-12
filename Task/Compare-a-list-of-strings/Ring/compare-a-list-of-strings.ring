a1=list(4)
a2=list(4)
a3=list(4)
a4=list(1)

  a1[1]="aaa" a1[2]="aaa" a1[3]="aaa" a1[4]="aaa"
  Test(a1,4)

  a2[1]="aaa" a2[2]="aab" a2[3]="aba" a2[4]="baa"
  Test(a2,4)

  a3[1]="aaa" a3[2]="aab" a3[3]="aba" a3[4]="aba"
  Test(a3,4)

  a4[1]="aaa"
  Test(a4,1)

func Test(ax,nr)
     flag = 0
     for n = 1 to nr-1
         if strcmp(ax[n],ax[n+1])=0
            flag = flag + 1
         ok
     next
     if flag = nr-1
        pflag(ax)
        see "All strings are lexically equal." + nl
     else
        pflag(ax)
        see "Not all strings are lexically equal." + nl
     ok

     flag = 0
     for n = 1 to nr-1
         if strcmp(ax[n],ax[n+1])<0
            flag = flag + 1
         ok
     next
     if flag = nr-1
        pflag(ax)
        see "The list is in strict ascending order." + nl
     else
        pflag(ax)
        see "The list is not in strict ascending order." + nl
     ok

func pflag(ax)
        see"Input array: ["
        for p = 1 to len(ax)
            see ax[p]
            if p = len(ax)
               see ""
            else
               see " "
            ok
        next
        see "]"+nl
