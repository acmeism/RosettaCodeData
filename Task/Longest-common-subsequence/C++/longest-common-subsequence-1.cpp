#include <stdint.h>
#include <string>
#include <memory>                       // for shared_ptr<>
#include <iostream>
#include <deque>
#include <map>
#include <algorithm>                    // for lower_bound()

using namespace std;

class LCS {
protected:
  // This linked list class is used to trace the LCS candidates
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
  typedef deque<uint32_t> THRESHOLD;
  typedef deque<uint32_t> INDEXES;
  typedef map<char, INDEXES> CHAR2INDEXES;
  typedef deque<INDEXES*> MATCHES;

  // return the LCS as a linked list of matched index pairs
  uint64_t LCS::Pairs(MATCHES& matches, shared_ptr<Pair> *pairs) {
    auto trace = pairs != nullptr;
    PAIRS traces;
    THRESHOLD threshold;

    //
    //[Assert]After each index1 iteration threshold[index3] is the least index2
    // such that the LCS of s1[0:index1] and s2[0:index2] has length index3 + 1
    //
    uint32_t index1 = 0;
    for (const auto& it1 : matches) {
      if (!it1->empty()) {
        auto dq2 = *it1;
        auto limit = threshold.end();
        for (auto it2 = dq2.begin(); it2 != dq2.end(); it2++)
        {
          // Each of the index1, index2 pairs considered here correspond to a match
          auto index2 = *it2;
          //
          // Note: The index2 values are monotonically decreasing, which allows the
          // thresholds to be updated in place.  Montonicity allows a binary search,
          // implemented here by std::lower_bound()
          //
          limit = lower_bound(threshold.begin(), limit, index2);
          auto index3 = distance(threshold.begin(), limit);

          //
          // Look ahead to the next index2 value to optimize space used in the Hunt
          // and Szymanski algorithm.  If the next index2 is also an improvement on
          // the value currently held in threshold[index3], a new Pair will only be
          // superseded on the next index2 iteration.
          //
          // Depending on match redundancy, the number of Pair constructions may be
          // divided by factors ranging from 2 up to 10 or more.
          //
          auto skip = it2 + 1 != dq2.end() &&
            (limit == threshold.begin() || *(limit - 1) < *(it2 + 1));

          if (skip) continue;

          if (limit == threshold.end()) {
            // insert case
            threshold.push_back(index2);
            if (trace) {
              auto prefix = index3 > 0 ? traces[index3 - 1] : nullptr;
              auto last = make_shared<Pair>(index1, index2, prefix);
              traces.push_back(last);
            }
          }
          else if (index2 < *limit) {
            // replacement case
            *limit = index2;
            if (trace) {
              auto prefix = index3 > 0 ? traces[index3 - 1] : nullptr;
              auto last = make_shared<Pair>(index1, index2, prefix);
              traces[index3] = last;
            }
          }
        }                                 // next index2
      }

      index1++;
    }                                     // next index1

    if (trace) {
      auto last = traces.size() > 0 ? traces.back() : nullptr;
      // Reverse longest back-trace
      *pairs = Pair::Reverse(last);
    }

    auto length = threshold.size();
    return length;
  }

  //
  // Match() avoids incurring m*n comparisons by using the associative memory
  // implemented by CHAR2INDEXES to achieve O(m+n) performance, where m and n
  // are the input lengths.
  //
  // The symbol space is sparse in the case of records; so, the lookup time is
  // at most O(log(m+n)).  The lookup time can be assumed constant in the case
  // of characters.
  //
  void Match(CHAR2INDEXES& indexes, MATCHES& matches,
    const string& s1, const string& s2) {
    uint32_t index = 0;
    for (const auto& it : s2)
      indexes[it].push_front(index++);

    for (const auto& it : s1) {
      auto& dq2 = indexes[it];
      matches.push_back(&dq2);
    }
  }

  string Select(shared_ptr<Pair> pairs, uint64_t length,
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
  string Correspondence(const string& s1, const string& s2) {
    CHAR2INDEXES indexes;
    MATCHES matches;                    // holds references into indexes
    Match(indexes, matches, s1, s2);
    shared_ptr<Pair> pairs;             // obtain the LCS as index pairs
    auto length = Pairs(matches, &pairs);
    return Select(pairs, length, false, s1, s2);
  }
};
