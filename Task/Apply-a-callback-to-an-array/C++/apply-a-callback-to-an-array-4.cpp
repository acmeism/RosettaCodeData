using namespace std;
using namespace boost::lambda;
vector<int> ary(10);
int i = 0;
for_each(ary.begin(), ary.end(), _1 = ++var(i)); // init array
transform(ary.begin(), ary.end(), ostream_iterator<int>(cout, " "), _1 * _1); // square and output
