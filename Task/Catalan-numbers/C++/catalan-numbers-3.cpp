#if !defined __TESTER_H__
#define __TESTER_H__

#include <iostream>

namespace rosetta
  {
  namespace catalanNumbers
    {

    template <int N, typename A>
    class Test
      {
      public:
        static void Do()
          {
          A algorithm;
          for(int i = 0; i <= N; i++)
            std::cout<<"C("<<i<<")\t= "<<algorithm(i)<<std::endl;
          }
      };

    } //namespace catalanNumbers
  }   //namespace rosetta

#endif //!defined __TESTER_H__
