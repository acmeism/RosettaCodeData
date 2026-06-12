# search for the string needle in the string haystack
def KMP::search(haystack; needle):

  def table_($needle):
    ($needle|length) as $nc
    | {t: [range(0; $nc) | 0],
       i: 1,   # index into table
       len: 0  # length of previous longest prefix
      }
    | until(.i >= .nc;
            if $needle[.i] == $needle[.len]
	    then .len += 1
            | .t[.i] = .len
            | .i += 1
            elif .len != 0
            then .len = .t[.len-1]
            else .t[.i] = 0
            | .i += 1
	    end )
    | .t ;

  { haystack: (haystack|explode),
    needle: (needle|explode),
    hc: (haystack|length),
    nc: (needle|length),
    indices: [],
    i: 0,        # index into haystack
    j: 0         # index into needle
  }
  | table_(.needle) as $t
  | until (.i >= .hc;
           if .needle[.j] == .haystack[.i]
           then .i += 1
           | .j += 1
           else .
           end
           | if .j == .nc
             then .indices = .indices + [.i - .j]
             | .j = $t[.j-1]
             elif (.i < .hc and .needle[.j] != .haystack[.i])
             then if .j != 0 then .j = $t[.j-1] else .i += 1 end
             else .
             end )
  | .indices ;


# Examples
def texts: [
    "GCTAGCTCTACGAGTCTA",
    "GGCTATAATGCGTA",
    "there would have been a time for such a word",
    "needle need noodle needle",
    "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented",
    "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk."
];

def pats: ["TCTA", "TAATAAA", "word", "needle", "put", "and", "alfalfa"];


def tasks($texts; $pats):
  range (0; $texts|length) | "text\(.+1) = \($texts[.])",
"",
  (range (0; $pats|length) as $i
   | (if $i < 5 then $i else $i-1 end) as $j
   | "Found '\($pats[$i])' in text\($j+1) at indices \(KMP::search($texts[$j]; $pats[$i]) )" ) ;

tasks(texts; pats)
