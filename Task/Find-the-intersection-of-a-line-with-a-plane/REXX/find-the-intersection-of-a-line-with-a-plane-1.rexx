/* REXX */
Parse Value '0 0 1' With n.1 n.2 n.3   /* Normal Vector of the plane */
Parse Value '0 0 5' With p.1 p.2 p.3   /* Point in the plane         */
Parse Value '0 0 10' With a.1 a.2 a.3  /* Point of the line          */
Parse Value '0 -1 -1' With v.1 v.2 v.3 /* Vector of the line         */

a=n.1
b=n.2
c=n.3
d=n.1*p.1+n.2*p.2+n.3*p.3  /* Parameter form of the plane */
Say a'*x +' b'*y +' c'*z =' d

t=(d-(a*a.1+b*a.2+c*a.3))/(a*v.1+b*v.2+c*v.3)

x=a.1+t*v.1
y=a.2+t*v.2
z=a.3+t*v.3

Say 'Intersection: P('||x','y','z')'
