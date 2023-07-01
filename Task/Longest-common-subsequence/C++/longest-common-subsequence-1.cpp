#include <stdint.h>
#include <string>
#include <memory>                       // for shared_ptr<>
#include <iostream>
#include <deque>
#include <unordered_map>                //[C++11]
#include <algorithm>                    // for lower_bound()
#include <iterator>                     // for next() and prev()

using namespace std;

class LCS {
protected:
  // Instances of the Pair linked list class are used to recover the LCS:
  class Pair {
  public:
    uint32_t index1;
    uint32_t index2;
    shared_ptr<Pair> next;

    Pair(uint32_t index1, uint32_t index2, shared_ptr<Pair> next = nullptr)
      : index1(index1), index2(index2), next(next) {
    }

    static shared_ptr<Pair> Reverse(const shared_ptr<Pair> pairs) {
      shared_ptr<Pair> head = nullptr;
      for (auto next = pairs; next != nullptr; next = next->next)
        head = make_shared<Pair>(next->index1, next->index2, head);
      return head;
    }
  };

  typedef deque<shared_ptr<Pair>> PAIRS;
  typedef deque<uint32_t> INDEXES;
  typedef unordered_map<char, INDEXES> CHAR_TO_INDEXES_MAP;
  typedef deque<INDEXES*> MATCHES;

  static uint32_t FindLCS(
    MATCHES& indexesOf2MatchedByIndex1, shared_ptr<Pair>* pairs) {
    auto traceLCS = pairs != nullptr;
    PAIRS chains;
    INDEXES prefixEnd;

    //
    //[Assert]After each index1 iteration prefixEnd[index3] is the least index2
    // such that the LCS of s1[0:index1] and s2[0:index2] has length index3 + 1
    //
    uint32_t index1 = 0;
    for (const auto& it1 : indexesOf2MatchedByIndex1) {
      auto dq2 = *it1;
      auto limit = prefixEnd.end();
      for (auto it2 = dq2.rbegin(); it2 != dq2.rend(); it2++) {
        // Each index1, index2 pair corresponds to a match
        auto index2 = *it2;

        //
        // Note: The reverse iterator it2 visits index2 values in descending order,
        // allowing in-place update of prefixEnd[].  std::lower_bound() is used to
        // perform a binary search.
        //
        limit = lower_bound(prefixEnd.begin(), limit, index2);

        //
        // Look ahead to the next index2 value to optimize Pairs used by the Hunt
        // and Szymanski algorithm.  If the next index2 is also an improvement on
        // the value currently held in prefixEnd[index3], a new Pair will only be
        // superseded on the next index2 iteration.
        //
        // Verify that a next index2 value exists; and that this value is greater
        // than the final index2 value of the LCS prefix at prev(limit):
        //
        auto preferNextIndex2 = next(it2) != dq2.rend() &&
          (limit == prefixEnd.begin() || *prev(limit) < *next(it2));

        //
        // Depending on match redundancy, this optimization may reduce the number
        // of Pair allocations by factors ranging from 2 up to 10 or more.
        //
        if (preferNextIndex2) continue;

        auto index3 = distance(prefixEnd.begin(), limit);

        if (limit == prefixEnd.end()) {
          // Insert Case
          prefixEnd.push_back(index2);
          // Refresh limit iterator:
          limit = prev(prefixEnd.end());
          if (traceLCS) {
            chains.push_back(pushPair(chains, index3, index1, index2));
          }
        }
        else if (index2 < *limit) {
          // Update Case
          // Update limit value:
          *limit = index2;
          if (traceLCS) {
            chains[index3] = pushPair(chains, index3, index1, index2);
          }
        }
      }                                   // next index2

      index1++;
    }                                     // next index1

    if (traceLCS) {
      // Return the LCS as a linked list of matched index pairs:
      auto last = chains.empty() ? nullptr : chains.back();
      // Reverse longest chain
      *pairs = Pair::Reverse(last);
    }

    auto length = prefixEnd.size();
    return length;
  }

private:
  static shared_ptr<Pair> pushPair(
    PAIRS& chains, const ptrdiff_t& index3, uint32_t& index1, uint32_t& index2) {
    auto prefix = index3 > 0 ? chains[index3 - 1] : nullptr;
    return make_shared<Pair>(index1, index2, prefix);
  }

protected:
  //
  // Match() avoids m*n comparisons by using CHAR_TO_INDEXES_MAP to
  // achieve O(m+n) performance, where m and n are the input lengths.
  //
  // The lookup time can be assumed constant in the case of characters.
  // The symbol space is larger in the case of records; but the lookup
  // time will be O(log(m+n)), at most.
  //
  static void Match(
    CHAR_TO_INDEXES_MAP& indexesOf2MatchedByChar, MATCHES& indexesOf2MatchedByIndex1,
    const string& s1, const string& s2) {
    uint32_t index = 0;
    for (const auto& it : s2)
      indexesOf2MatchedByChar[it].push_back(index++);

    for (const auto& it : s1) {
      auto& dq2 = indexesOf2MatchedByChar[it];
      indexesOf2MatchedByIndex1.push_back(&dq2);
    }
  }

  static string Select(shared_ptr<Pair> pairs, uint32_t length,
    bool right, const string& s1, const string& s2) {
    string buffer;
    buffer.reserve(length);
    for (auto next = pairs; next != nullptr; next = next->next) {
      auto c = right ? s2[next->index2] : s1[next->index1];
      buffer.push_back(c);
    }
    return buffer;
  }

public:
  static string Correspondence(const string& s1, const string& s2) {
    CHAR_TO_INDEXES_MAP indexesOf2MatchedByChar;
    MATCHES indexesOf2MatchedByIndex1;  // holds references into indexesOf2MatchedByChar
    Match(indexesOf2MatchedByChar, indexesOf2MatchedByIndex1, s1, s2);
    shared_ptr<Pair> pairs;             // obtain the LCS as index pairs
    auto length = FindLCS(indexesOf2MatchedByIndex1, &pairs);
    return Select(pairs, length, false, s1, s2);
  }
};
