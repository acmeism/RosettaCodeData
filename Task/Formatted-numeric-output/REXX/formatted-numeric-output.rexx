/*REXX program shows various ways to  add leading zeroes  to numbers.   */
a=7.125
b=translate(format(a,10),0,' ')
say 'a=' a
say 'b=' b
say

c=8.37
d=right(c,20,0)
say 'c=' c
say 'd=' d
say

e=19.46
f='000000'e
say 'e=' e
say 'f=' f
say

g=18.25e+1
h=000000||g
say 'g=' g
say 'h=' h
say

i=45.2
j=translate('      'i,0," ")
say 'i=' i
say 'j=' j
say

k=36.007
l=insert(00000000,k,0)
say 'k=' k
say 'l=' l
say

m=.10055
n=copies(0,20)m
say 'm=' m
say 'n=' n
say

p=4.060
q=0000000000000||p
say 'p=' p
say 'q=' q
say

r=876
s=substr(r+10000000,2)
say 'r=' r
say 's=' s
say

t=13.02
u=reverse(reverse(t)000000000)
say 't=' t
say 'u=' u
                                      /*stick a fork in it, we're done.*/
