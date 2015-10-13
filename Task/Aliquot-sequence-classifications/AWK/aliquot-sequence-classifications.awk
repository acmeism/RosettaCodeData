#!/bin/gawk -f
function sumprop(num,   i,sum,root) {
if (num == 1) return 0
sum=1
root=sqrt(num)
for ( i=2; i < root; i++) {
    if (num % i == 0 )
    {
    sum = sum + i + num/i
    }
    }
if (num % root == 0)
   {
    sum = sum + root
   }
return sum
}
function class(k,    oldk,newk,seq){
# first term
oldk = k
seq = " "
# second term
newk = sumprop(oldk)
oldk = newk
seq = seq " " newk
if (newk == 0) return "terminating " seq
if (newk == k) return "perfect " seq
#  third term
newk = sumprop(oldk)
oldk = newk
seq = seq " " newk
if (newk == 0) return "terminating " seq
if (newk == k) return "amicable " seq
for (t=4; t<17; t++) {
newk = sumprop(oldk)
seq = seq " " newk
if (newk == 0) return "terminating " seq
if (newk == k) return "sociable (period " t-1 ") "seq
if (newk == oldk) return "aspiring " seq
if (index(seq," " newk " ") > 0) return "cyclic (at " newk ") " seq
if (newk > 140737488355328) return "non-terminating (term > 140737488355328) " seq
oldk = newk
}
return "non-terminating (after 16 terms)  " seq
}
BEGIN{
print "Number classification sequence"
for (j=1; j < 11; j++)
    {
    print j,class(j)}
    print 11,class(11)
    print 12,class(12)
    print 28,class(28)
    print 496,class(496)
    print 220,class(220)
    print 1184,class(1184)
    print 12496,class(12496)
    print 1264460,class(1264460)
    print 790,class(790)
    print 909,class(909)
    print 562,class(562)
    print 1064,class(1064)
    print 1488,class(1488)
    print 15355717786080,class(15355717786080)

}
