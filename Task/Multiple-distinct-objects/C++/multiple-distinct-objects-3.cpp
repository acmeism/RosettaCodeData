#include <vector>
#include <tr1/memory>
using namespace std;
using namespace std::tr1;

typedef shared_ptr<T> TPtr_t;
// the following is NOT correct:
std::vector<TPtr_t > bvec_WRONG(n, p); // create n copies of p, which all point to the same opject p points to.

// nor is this:
std::vector<TPtr_t> bvec_ALSO_WRONG(n, TPtr_t(new T(*p)) ); // create n pointers to a single copy of *p

// the correct solution
std::vector<TPtr_t > bvec(n);
for (int i = 0; i < n; ++i)
  bvec[i] = TPtr_t(new T(*p); //or any other call to T's constructor

// another correct solution
// this solution avoids uninitialized pointers at any point
std::vector<TPtr_t> bvec2;
for (int i = 0; i < n; ++i)
  bvec2.push_back(TPtr_t(new T(*p));
