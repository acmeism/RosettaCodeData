#include <stdio.h>
main(){_=100;while(--_)printf("%i bottle%s of beer in the wall,\n%i bottle%"
"s of beer.\nTake one down, pass it round,\n%s%s\n\n",_,_-1?"s":"",_,_-1?"s"
:"",_-1?(char[]){(_-1)/10?(_-1)/10+48:(_-1)%10+48,(_-1)/10?(_-1)%10+48:2+30,
(_-1)/10?32:0,0}:"",_-1?"bottles of beer in the wall":"No more beers");}
