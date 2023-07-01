/*
Michal Sikorski
06/07/2016
*/
#include <cstdlib>
#include <iostream>
#include <windows.h>
#include <string.h>
using namespace std;
int main(int argc, char *argv[])
{
    string inpt;
    char ascii[28] = " ABCDEFGHIJKLMNOPQRSTUVWXYZ", lwcAscii[28] = " abcdefghijklmnopqrstuvwxyz";
    string morse[27] = {"  ", ".- ", "-... ", "-.-. ", "-.. ", ". ", "..-. ", "--. ", ".... ", ".. ", ".--- ", "-.- ", ".-.. ", "-- ", "-. ", "--- ", ".--.", "--.- ", ".-. ", "... ", "- ", "..- ", "...- ", ".-- ", "-..- ", "-.-- ", "--.. "};
    string outpt;
    getline(cin,inpt);
    int xx=0;
    int size = inpt.length();
    cout<<"Length:"<<size<<endl;

    xx=0;
    while(xx<inpt.length())
    {
                         int x=0;
                         bool working = false;
                         while(!working)
                         {
                                  if(ascii[x] != inpt[xx]&&lwcAscii[x] != inpt[xx])
                                  {
                                        x++;
                                  }
                                  else
                                  {
                                        working = !working;
                                  }
                         }

                         cout<<morse[x];
                         outpt = outpt + morse[x];
                         xx++;
    }

    xx=0;
    while(xx<outpt.length()+1)
    {
                         if(outpt[xx] == '.')
                         {
                                   Beep(1000,250);
                         }
                         else
                         {
                             if(outpt[xx] == '-')
                             {
                                          Beep(1000,500);
                             }
                             else
                             {
                                 if(outpt[xx] == ' ')
                                 {
                                              Sleep(500);
                                 }
                             }
                         }
                         xx++;
    }
    system("PAUSE");
    return EXIT_SUCCESS;
}
