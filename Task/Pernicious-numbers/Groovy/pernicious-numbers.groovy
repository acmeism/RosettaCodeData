class example{
static void main(String[] args){
def n=0;
def counter=0;
while(counter<25){
if(print(n)){
counter++;}
n=n+1;
}
println();
def x=888888877;
while(x<888888889){
print(x);
x++;}
}
static def print(def a){
def primes=[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47];
def c=Integer.toBinaryString(a);
String d=c;
def e=0;
for(i in d){if(i=='1'){e++;}}
if(e in primes){printf(a+" ");return 1;}
}
}
