version(D_Version2) {

  static if( __traits(compiles,abs(bloop)) ) {

   typeof(abs(bloop)) computeAbsBloop()  {
      return abs(bloop);
   }

  }
 } else static assert(0, "Requires D version 2");
