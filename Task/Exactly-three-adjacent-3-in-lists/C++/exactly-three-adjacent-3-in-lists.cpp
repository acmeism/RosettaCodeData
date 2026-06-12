#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <ranges>
#include <vector>

int main() {
    std::vector<std::vector<int32_t>> lists = { { 9, 3, 3, 3, 2, 1, 7, 8, 5 },
        { 5, 2, 9, 3, 3, 7, 8, 4, 1 }, { 1, 4, 3, 6, 7, 3, 8, 3, 2 },
        { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, { 4, 6, 8, 7, 2, 3, 3, 3, 1 }
    };

    for ( uint32_t i = 0; i < lists.size(); ++i ) {
        bool count_started = false;
        bool success = true;
        int32_t count = 0;
        for ( uint32_t j = 0; j < lists[i].size(); ++j ) {
            if ( lists[i][j] == 3 ) {
                count += 1;
                count_started = true;
            } else {
                if  ( count_started && count != 3 ) {
                    success = false;
                }
                count_started = false;
            }
        }

        std::ranges::copy(lists[i], std::ostream_iterator<int32_t>(std::cout, " "));
        std::cout << "=> " << std::boolalpha << success << std::endl;
    }

}
