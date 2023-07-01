import std.stdio, std.string, std.conv, std.algorithm, std.format, std.array,
       std.range, std.digest.sha;

int rol(int n, int b) {
  return ((n << b) | (n >>> (32 - b))) & 0xffffffff;
}

int btoi(string bin) {
  int total = 0;
  foreach (b; bin) {
    total *= 2;
    (b == '1') ? total += 1 : total;
  }
  return total;
}

string sha1(char[] intake) {
  int h0 = 0x67452301;
  int h1 = 0xEFCDAB89;
  int h2 = 0x98BADCFE;
  int h3 = 0x10325476;
  int h4 = 0xC3D2E1F0;

  auto bins = intake.map!(x => format("%08b", x.to!int));
  int binsize = bins.join().length.to!int;
  string o = bins.join() ~ "1";
  o ~= replicate("0", 448%512 - o.length.to!int%512) ~ format("%064b", binsize);
  auto binchunks = chunks(o, 512).array;
  foreach (chunk; binchunks) {
    string[] words = chunk.chunks(512/16).array
                       .map!(x => "%032s".format(x)).array;
    foreach (i; iota(16, 80)) {
      int newWord = btoi(words[i-3]) ^ btoi(words[i-8]) ^
                    btoi(words[i-14]) ^ btoi(words[i-16]);
      newWord = rol(newWord, 1);
      words = words.array ~ "%032b".format(newWord);
    }
    int A = h0;
    int B = h1;
    int C = h2;
    int D = h3;
    int E = h4;
    foreach (i; iota(0, 80)) {
      int F = 0;
      int K = 0;
      if (i < 20) {
        F = D ^ (B & (C ^ D));
        K = 0x5A827999;
      }
      else if (i < 40) {
        F = B ^ C ^ D;
        K = 0x6ED9EBA1;
      }
      else if (i < 60) {
        F = (B & C) | (B & D) | (C & D);
        K = 0x8F1BBCDC;
      }
      else if (i < 80) {
        F = B ^ C ^ D;
        K = 0xCA62C1D6;
      }
      int tempA = A;
      A = rol(A, 5) + F + E + K + btoi(words[i]) & 0xffffffff;
      E = D;
      D = C;
      C = rol(B,30);
      B = tempA;
    }

    h0 = btoi("%032b".format(h0 + A).retro.array[0 .. 32].retro.to!string);
    h1 = btoi("%032b".format(h1 + B).retro.array[0 .. 32].retro.to!string);
    h2 = btoi("%032b".format(h2 + C).retro.array[0 .. 32].retro.to!string);
    h3 = btoi("%032b".format(h3 + D).retro.array[0 .. 32].retro.to!string);
    h4 = btoi("%032b".format(h4 + E).retro.array[0 .. 32].retro.to!string);
  }
  return "%08x%08x%08x%08x%08x".format(h0, h1, h2, h3, h4);
}

void main() {
  writeln(sha1("Rosetta Code".dup));
}
