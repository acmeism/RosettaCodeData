#include <vector>
#include "boost/random.hpp"
#include "boost/generator_iterator.hpp"
#include <boost/random/normal_distribution.hpp>
#include <algorithm>

typedef boost::mt19937 RNGType; ///< mersenne twister generator

int main() {
    RNGType rng;
    boost::normal_distribution<> rdist(1.0,0.5); /**< normal distribution
                           with mean of 1.0 and standard deviation of 0.5 */

    boost::variate_generator< RNGType, boost::normal_distribution<> >
                    get_rand(rng, rdist);

    std::vector<double> v(1000);
    generate(v.begin(),v.end(),get_rand);
    return 0;
}
