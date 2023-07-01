#!/usr/bin/awk -f
BEGIN {
     a[1] = 3; a[2]= 4; a[3] = 5;
     b[1] = 4; b[2]= 3; b[3] = 5;
     c[1] = -5; c[2]= -12; c[3] = -13;

     print "a = ",printVec(a);
     print "b = ",printVec(b);
     print "c = ",printVec(c);
     print "a.b = ",dot(a,b);
     ## upper case variables are used as temporary or intermediate results
     cross(a,b,D);print "a.b = ",printVec(D);
     cross(b,c,D);print "a.(b x c) = ",dot(a,D);
     cross(b,c,D);cross(a,D,E); print "a x (b x c) = ",printVec(E);
}

function dot(A,B) {
     return A[1]*B[1]+A[2]*B[2]+A[3]*B[3];
}

function cross(A,B,C) {
     C[1] = A[2]*B[3]-A[3]*B[2];
     C[2] = A[3]*B[1]-A[1]*B[3];
     C[3] = A[1]*B[2]-A[2]*B[1];
}

function printVec(C) {
    return "[ "C[1]" "C[2]" "C[3]" ]";
}
