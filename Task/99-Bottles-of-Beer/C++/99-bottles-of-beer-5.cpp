                          //>,_
                        //Beer Song>,_
                       #include <iostream>
                      using namespace std;
                     int main(){ for( int
                    b=-1; b<99;  cout <<
                   '\n') for ( int w=0;
                  w<3; cout << ".\n"){
                 if (w==2) cout << ((
                b--) ?"Take one dow"
               "n and pass it arou"
              "nd":"Go to the sto"
             "re and buy some mo"
            "re"); if (b<0) b=99
           ; do{ if (w) cout <<
          ", "; if (b) cout <<
          b;  else  cout << (
         (w) ? 'n' : 'N') <<
         "o more"; cout <<
         " bottle" ;  if
        (b!=1) cout <<
       's' ; cout <<
       " of beer";
      if (w!=1)
     cout  <<
    " on th"
   "e wall"
  ;} while
 (!w++);}
  return
       0
       ;
       }
      //
  // by barrym 2011-05-01
     // no bottles were harmed in the
            // making of this program!!!
