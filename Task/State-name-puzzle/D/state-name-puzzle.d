import std.stdio, std.algorithm, std.string, std.exception;

auto states = ["Alabama", "Alaska", "Arizona", "Arkansas",
"California", "Colorado", "Connecticut", "Delaware", "Florida",
"Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas",
"Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts",
"Michigan", "Minnesota", "Mississippi", "Missouri", "Montana",
"Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico",
"New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma",
"Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
"South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia",
"Washington", "West Virginia", "Wisconsin", "Wyoming",
// Uncomment the next line for the fake states.
// "New Kory", "Wen Kory", "York New", "Kory New", "New Kory"
];

void main() {
  states.length -= states.sort().uniq.copy(states).length;

  string[][const ubyte[]] smap;
  foreach (immutable i, s1; states[0 .. $ - 1])
    foreach (s2; states[i + 1 .. $])
      smap[(s1 ~ s2).dup.representation.sort().release.assumeUnique]
        ~= s1 ~ " + " ~ s2;

  writefln("%-(%-(%s = %)\n%)",
           smap.values.sort().filter!q{ a.length > 1 });
}
