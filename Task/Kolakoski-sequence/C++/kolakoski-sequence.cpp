#include <iostream>
#include <vector>

using Sequence = std::vector<int>;

std::ostream& operator<<(std::ostream& os, const Sequence& v) {
  os << "[ ";
  for (const auto& e : v) {
    std::cout << e << ", ";
  }
  os << "]";
  return os;
}

int next_in_cycle(const Sequence& s, size_t i) {
  return s[i % s.size()];
}

Sequence gen_kolakoski(const Sequence& s, int n) {
  Sequence seq;
  for (size_t i = 0; seq.size() < n; ++i) {
    const int next = next_in_cycle(s, i);
    Sequence nv(i >= seq.size() ? next : seq[i], next);
    seq.insert(std::end(seq), std::begin(nv), std::end(nv));
  }
  return { std::begin(seq), std::begin(seq) + n };
}

bool is_possible_kolakoski(const Sequence& s) {
  Sequence r;
  for (size_t i = 0; i < s.size();) {
    int count = 1;
    for (size_t j = i + 1; j < s.size(); ++j) {
      if (s[j] != s[i]) break;
      ++count;
    }
    r.push_back(count);
    i += count;
  }
  for (size_t i = 0; i < r.size(); ++i) if (r[i] != s[i]) return false;
  return true;
}

int main() {
  std::vector<Sequence> seqs = {
    { 1, 2 },
    { 2, 1 },
    { 1, 3, 1, 2 },
    { 1, 3, 2, 1 }
  };
  for (const auto& s : seqs) {
    auto kol = gen_kolakoski(s, s.size() > 2 ? 30 : 20);
    std::cout << "Starting with: " << s << ": " << std::endl << "Kolakoski sequence: "
      << kol << std::endl << "Possibly kolakoski? " << is_possible_kolakoski(kol) << std::endl;		
  }
  return 0;
}
