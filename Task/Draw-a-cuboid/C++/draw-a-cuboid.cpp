#include<graphics.h>
#include<iostream>

int main()
{
    int k;
    initwindow(1500,810,"Rosetta Cuboid");

    do{
       std::cout<<"Enter ratio of sides ( 0 or -ve to exit) : ";
       std::cin>>k;

       if(k>0){
                bar3d(100, 100, 100 + 2*k, 100 + 4*k, 3*k, 1);
       }
       }while(k>0);

    return 0;
}
