/* generalized Kronecker delta - antisymmetrizer */
template<ari T, size_t N>
constexpr int8_t gkd(const std::array<T,N>& v, const std::array<T,N>& orig)
{
        bool trans = 0;
        for(size_t i = 0; i < orig.size(); i++)
        {
                size_t cnt = 0;
                for(size_t j = 0; j < std::min<size_t>(i + 1,v.size()); j++)
                        if(orig[i] == v[j]) ++cnt;
                for(size_t j = i + 1; j < v.size(); j++)
                {
                        if(orig[i] == v[j]) ++cnt;
                        if(   v[i] >  v[j]) trans += -1;
                }
                if(cnt != 1) return 0;
        }
        return trans ? -1 : 1;
}

/* generalized permanent delta - complete symmetrizer *
 * equivalent to abs(gKd(v,orig)) or is_index_sequence */
template<ari T, size_t N>
inline constexpr int8_t gpd(const std::array<T,N>& v, const std::array<T,N>& orig)
{
        for(auto& i : orig)
                if(std::count(v.begin(), v.end(), i) != 1) return 0;
        return 1;
}
