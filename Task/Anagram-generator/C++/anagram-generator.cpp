#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <map>
#include <set>
#include <string>
#include <vector>

std::vector<std::string> create_combinations(
      const std::string& word, const size_t& k) {
   std::vector<std::string> combinations{ };
   std::vector<bool> visited(word.size());
   std::fill(visited.end() - k, visited.end(), true);
   while ( std::next_permutation(visited.begin(), visited.end()) ) {
      std::string combination{ };
      for ( uint32_t i = 0; i < word.size(); ++i ) {
         if ( visited[i] ) {
            combination.push_back(word[i]);
         }
      }
      combinations.emplace_back(combination);
   }
   return combinations;
}

void anagram_generator(std::string word, const std::map<std::string, std::vector<std::string>>& word_map) {
   word.erase(std::remove_if(word.begin(), word.end(), [](unsigned char c) { return !std::isalpha(c); }), word.end());
   std::transform(word.cbegin(), word.cend(), word.begin(), [](unsigned char c) { return std::tolower(c); });
   std::sort(word.begin(), word.end());

   std::set<std::string> previous_letters{ };

   for ( size_t n = word.size() / 2; n >= 1; --n ) {
      for ( std::string letters_one : create_combinations(word, n) ) {
         std::sort(letters_one.begin(), letters_one.end());

         if (!previous_letters.insert(letters_one).second) {
            continue;
         }

         std::map<std::string, std::vector<std::string>>::const_iterator it = word_map.find(letters_one);
         if (it != word_map.end()) {
            std::vector<std::string> anagrams_one = it->second;
            std::string letters_two{ };
            std::set_difference(word.begin(), word.end(),
               letters_one.begin(), letters_one.end(), std::back_inserter(letters_two));

            if (word.size() == 2 * n) {
               if (!previous_letters.insert(letters_two).second) {
                  continue;
               }
            }

            std::map<std::string, std::vector<std::string>>::const_iterator it = word_map.find(letters_two);
            if (it != word_map.end()) {
               std::vector<std::string> anagrams_two = it->second;
               for (const std::string& word_one : anagrams_one) {
                  for (const std::string& word_two : anagrams_two) {
                     std::cout << " " << word_one << " " << word_two << std::endl;
                  }
               }
            }
         }
      }
   }
}

int main() {
   std::map<std::string, std::vector<std::string>> word_map{ };
   {
      std::fstream file_stream{ "../unixdict.txt" };
      std::string word;
      while (file_stream >> word) {
         std::string sorted_word = word;
         std::sort(sorted_word.begin(), sorted_word.end());

         word_map[sorted_word].emplace_back(word);
      }
   }

   std::vector<std::string> words{ "Rosetta code", "Joe B'iden", "Clint Eastw3ood" };
   for (const std::string& word : words) {
      std::cout << "Two word anagrams of " << word << ":" << std::endl;
      anagram_generator(word, word_map);
      std::cout << std::endl;
   }
}
