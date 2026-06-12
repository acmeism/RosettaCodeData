#include<array>
#include<utility>
#include<cmath>
#include<random>
#include<iostream>

using coord = std::pair<int,int>;
constexpr size_t numCities = 100;

// CityID with member functions to get position
struct CityID{
    int v{-1};
    CityID() = default;
    constexpr explicit CityID(int i) noexcept : v(i){}
    constexpr explicit CityID(coord ij) : v(ij.first * 10 + ij.second) {
        if(ij.first < 0 || ij.first > 9 || ij.second < 0 || ij.second > 9){
            throw std::logic_error("Cannot construct CityID from invalid coordinates!");
        }
    }

    constexpr coord get_pos() const noexcept { return {v/10,v%10}; }
};
bool operator==(CityID const& lhs, CityID const& rhs) {return lhs.v == rhs.v;}

// Function for distance between two cities
double dist(coord city1, coord city2){
    double diffx = city1.first - city2.first;
    double diffy = city1.second - city2.second;
    return std::sqrt(std::pow(diffx, 2) + std::pow(diffy,2));
}

// Function for total distance travelled
template<size_t N>
double dist(std::array<CityID,N> cities){
    double sum = 0;
    for(auto it = cities.begin(); it < cities.end() - 1; ++it){
        sum += dist(it->get_pos(),(it+1)->get_pos());
    }
    sum += dist((cities.end()-1)->get_pos(), cities.begin()->get_pos());
    return sum;
}

// 8 nearest cities, id cannot be at the border and has to have 8 valid neighbors
constexpr std::array<CityID,8> get_nearest(CityID id){
    auto const ij = id.get_pos();
    auto const i = ij.first;
    auto const j = ij.second;
    return {
        CityID({i-1,j-1}),
        CityID({i  ,j-1}),
        CityID({i+1,j-1}),
        CityID({i-1,j  }),
        CityID({i+1,j  }),
        CityID({i-1,j+1}),
        CityID({i  ,j+1}),
        CityID({i+1,j+1}),
    };
}

// Function for formating of results
constexpr int get_num_digits(int num){
    int digits = 1;
    while(num /= 10){
        ++digits;
    }
    return digits;
}

// Function for shuffeling of initial state
template<typename It, typename RandomEngine>
void shuffle(It first, It last, RandomEngine& rand_eng){
    for(auto i=(last-first)-1; i>0; --i){
        std::uniform_int_distribution<int> dist(0,i);
        std::swap(first[i], first[dist(rand_eng)]);
    }
}

class SA{
    int kT{1};
    int kmax{1'000'000};
    std::array<CityID,numCities> s;
    std::default_random_engine rand_engine{0};

    // Temperature
    double temperature(int k) const { return kT * (1.0 - static_cast<double>(k) / kmax); }

    // Probabilty of acceptance between 0.0 and 1.0
    double P(double dE, double T){
        if(dE < 0){
            return 1;
        }
        else{
            return std::exp(-dE/T);
        }
    }

    // Permutation of state through swapping of cities in travel path
    std::array<CityID,numCities> next_permut(std::array<CityID,numCities> cities){
        std::uniform_int_distribution<> disx(1,8);
        std::uniform_int_distribution<> disy(1,8);
        auto randCity = CityID({disx(rand_engine),disy(rand_engine)});      // Select city which is not at the border, since all neighbors are valid under this condition and all permutations are still possible
        auto neighbors = get_nearest(randCity);                             // Get list of nearest neighbors
        std::uniform_int_distribution<> selector(0,neighbors.size()-1);     // [0,7]
        const auto [i,j] = randCity.get_pos();
        auto randNeighbor = neighbors[selector(rand_engine)];               // Since randCity is not at the border, all 8 neighbors are valid
        auto cityit1 = std::find(cities.begin(),cities.end(),randCity);     // Find selected city in state
        auto cityit2 = std::find(cities.begin(), cities.end(),randNeighbor);// Find selected neighbor in state
        std::swap(*cityit1, *cityit2);                                      // Swap city and neighbor
        return cities;
    }

    // Logging function for progress output
    void log_progress(int k, double T, double E) const {
        auto nk = get_num_digits(kmax);
        auto nt = get_num_digits(kT);
        std::printf("k: %*i | T: %*.3f | E(s): %*.4f\n", nk, k, nt, T, 3, E);
    }
public:

    // Initialize state with integers from 0 to 99
    SA() {
        int i = 0;
        for(auto it = s.begin(); it != s.end(); ++it){
            *it = CityID(i);
            ++i;
        }
        shuffle(s.begin(),s.end(),rand_engine);
    }

    // Logging function for final path
    void log_path(){
        for(size_t idx = 0; idx < s.size(); ++idx){
            std::printf("%*i -> ", 2, s[idx].v);
            if((idx + 1)%20 == 0){
                std::printf("\n");
            }
        }
        std::printf("%*i", 2, s[0].v);
    }

    // Core simulated annealing algorithm
    std::array<CityID,numCities> run(){
        std::cout << "kT == " << kT << "\n" << "kmax == " << kmax << "\n" << "E(s0) == " << dist(s) << "\n";
        for(int k = 0; k < kmax; ++k){
            auto T = temperature(k);
            auto const E1 = dist(s);
            auto s_next{next_permut(s)};
            auto const E2 = dist(s_next);
            auto const dE = E2 - E1; // lower is better
            std::uniform_real_distribution dist(0.0, 1.0);
            auto E = E1;
            if(P(dE,T) >= dist(rand_engine)){
                s = s_next;
                E = E2;
            }
            if(k%100000 == 0){
                log_progress(k,T,E1);
            }
        }
        log_progress(kmax,0.0,dist(s));
        std::cout << "\nFinal path: \n";
        log_path();
        return s;
    }
};

int main(){
    SA sa{};
    auto result = sa.run(); // Run simulated annealing and log progress and result
    std::cin.get();
    return 0;
}
