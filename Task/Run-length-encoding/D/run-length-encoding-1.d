import std.algorithm, std.array;

alias encode = group;

auto decode(Group!("a == b", string) enc) {
    return enc.map!(t => [t[0]].replicate(t[1])).join;
}

void main() {
    immutable s = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWW" ~
                  "WWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW";
    assert(s.encode.decode.equal(s));
}
