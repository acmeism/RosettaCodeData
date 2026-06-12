import std.stdio;
import std.typecons;

alias Pair = Tuple!(int, int);

auto check_seq(int pos, int[] seq, int n, int min_len) {
    if (pos>min_len || seq[0]>n) return Pair(min_len, 0);
    else if (seq[0] == n)        return Pair(    pos, 1);
    else if (pos<min_len)        return try_perm(0, pos, seq, n, min_len);
    else                         return Pair(min_len, 0);
}

auto try_perm(int i, int pos, int[] seq, int n, int min_len) {
    if (i>pos) return Pair(min_len, 0);

    auto res1 = check_seq(pos+1, [seq[0]+seq[i]]~seq, n, min_len);
    auto res2 = try_perm(i+1, pos, seq, n, res1[0]);

    if (res2[0] < res1[0])       return res2;
    else if (res2[0] == res1[0]) return Pair(res2[0], res1[1]+res2[1]);
    else                         throw new Exception("Try_perm exception");
}

auto init_try_perm = function(int x) => try_perm(0, 0, [1], x, 12);

void find_brauer(int num) {
    auto res = init_try_perm(num);
    writeln;
    writeln("N = ", num);
    writeln("Minimum length of chains: L(n)= ", res[0]);
    writeln("Number of minimum length Brauer chains: ", res[1]);
}

void main() {
    auto nums = [7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379];
    foreach (i; nums) {
        find_brauer(i);
    }
}
