#include <cstdio>
#include <vector>
#include <bits/stdc++.h>

using namespace std;

int main() {
  vector<tuple<int, int>> w; int lst[4] = { 2, 3, 5, 7 }, sum;
  for (int x : lst) w.push_back({x, x});
  while (w.size() > 0) { auto i = w[0]; w.erase(w.begin());
    for (int x : lst) if ((sum = get<1>(i) + x) == 13)
        printf("%d%d ", get<0>(i), x);
      else if (sum < 12) w.push_back({get<0>(i) * 10 + x, sum}); }
  return 0; }
