using System; using static System.Console;
class Program { static void Main(string[] args) {
    for (int i=0,j=-6,k=1,c=0,s=0;s<1600000;s+=c+=k+=j+=6)
      Write("{0,-7}{1}",s, (i+=i==3?-4:1)==0?"\n":" "); } }
