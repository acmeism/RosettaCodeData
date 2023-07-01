#include <iostream>
#include <string>
#include <map>
#include <algorithm> // for min, max
using namespace std;

class StraddlingCheckerboard
{
  map<char, string> table;
  char first[10], second[10], third[10];
  int rowU, rowV;

public:
  StraddlingCheckerboard(const string &alphabet, int u, int v)
  {
    rowU = min(u, v);
    rowV = max(u, v);

    for(int i = 0, j = 0; i < 10; ++i)
    {
      if(i != u && i != v)
      {
        first[i] = alphabet[j];
        table[alphabet[j]] = '0' + i;
        ++j;
      }

      second[i] = alphabet[i+8];
      table[alphabet[i+8]] = '0' + rowU;
      table[alphabet[i+8]] += '0' + i;

      third[i] = alphabet[i+18];
      table[alphabet[i+18]] = '0' + rowV;
      table[alphabet[i+18]] += '0' + i;
    }
  }

  string encode(const string &plain)
  {
    string out;
    for(int i = 0; i < plain.size(); ++i)
    {
      char c = plain[i];
      if(c >= 'a' && c <= 'z')
        c += 'A' - 'a';

      if(c >= 'A' && c <= 'Z')
        out += table[c];
      else if(c >= '0' && c <= '9')
      {
        out += table['/'];
        out += c;
      }
    }
    return out;
  }

  string decode(const string &cipher)
  {
    string out;
    int state = 0;
    for(int i = 0; i < cipher.size(); ++i)
    {
      int n = cipher[i] - '0';
      char next = 0;

      if(state == 1)
        next = second[n];
      else if(state == 2)
        next = third[n];
      else if(state == 3)
        next = cipher[i];
      else if(n == rowU)
        state = 1;
      else if(n == rowV)
        state = 2;
      else
        next = first[n];

      if(next == '/')
        state = 3;
      else if(next != 0)
      {
        state = 0;
        out += next;
      }
    }
    return out;
  }
};
