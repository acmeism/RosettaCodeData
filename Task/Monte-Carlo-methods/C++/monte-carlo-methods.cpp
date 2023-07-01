#include<iostream>
#include<math.h>
#include<stdlib.h>
#include<time.h>

using namespace std;
int main(){
    int jmax=1000; // maximum value of HIT number. (Length of output file)
    int imax=1000; // maximum value of random numbers for producing HITs.
    double x,y;    // Coordinates
    int hit;       // storage variable of number of HITs
    srand(time(0));
    for (int j=0;j<jmax;j++){
        hit=0;
        x=0; y=0;
        for(int i=0;i<imax;i++){
            x=double(rand())/double(RAND_MAX);
            y=double(rand())/double(RAND_MAX);
        if(y<=sqrt(1-pow(x,2))) hit+=1; }          //Choosing HITs according to analytic formula of circle
    cout<<""<<4*double(hit)/double(imax)<<endl; }  // Print out Pi number
}
