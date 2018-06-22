import std.algorithm;
import std.stdio;

void main() {
    immutable scores = [
        "Solomon": 44,
        "Jason": 42,
        "Errol": 42,
        "Garry": 41,
        "Bernard": 41,
        "Barry": 41,
        "Stephen": 39
    ];

    scores.standardRank;
    scores.modifiedRank;
    scores.denseRank;
    scores.ordinalRank;
    scores.fractionalRank;
}

/*
Standard ranking
1 44 Solomon
2 42 Jason
2 42 Errol
4 41 Garry
4 41 Bernard
4 41 Barry
7 39 Stephen
*/
void standardRank(const int[string] data) {
    writeln("Standard Rank");

    int rank = 1;
    foreach (value; data.values.dup.sort!"a>b".uniq) {
        int temp = rank;
        foreach(k,v; data) {
            if (v==value) {
                writeln(temp, " ", v, " ", k);
                rank++;
            }
        }
    }

    writeln;
}

/*
Modified ranking
1 44 Solomon
3 42 Jason
3 42 Errol
6 41 Garry
6 41 Bernard
6 41 Barry
7 39 Stephen
*/
void modifiedRank(const int[string] data) {
    writeln("Modified Rank");

    int rank = 0;
    foreach (value; data.values.dup.sort!"a>b".uniq) {
        foreach(k,v; data) {
            if (v==value) {
                rank++;
            }
        }
        foreach(k,v; data) {
            if (v==value) {
                writeln(rank, " ", v, " ", k);
            }
        }
    }

    writeln;
}

/*
Dense ranking
1 44 Solomon
2 42 Jason
2 42 Errol
3 41 Garry
3 41 Bernard
3 41 Barry
4 39 Stephen
*/
void denseRank(const int[string] data) {
    writeln("Dense Rank");

    int rank = 1;
    foreach (value; data.values.dup.sort!"a>b".uniq) {
        foreach(k,v; data) {
            if (v==value) {
                writeln(rank, " ", v, " ", k);
            }
        }
        rank++;
    }

    writeln;
}

/*
Ordinal ranking
1 44 Solomon
2 42 Jason
3 42 Errol
4 41 Garry
5 41 Bernard
6 41 Barry
7 39 Stephen
*/
void ordinalRank(const int[string] data) {
    writeln("Ordinal Rank");

    int rank = 1;
    foreach (value; data.values.dup.sort!"a>b".uniq) {
        foreach(k,v; data) {
            if (v==value) {
                writeln(rank, " ", v, " ", k);
                rank++;
            }
        }
    }

    writeln;
}

/*
Fractional ranking
1,0 44 Solomon
2,5 42 Jason
2,5 42 Errol
5,0 41 Garry
5,0 41 Bernard
5,0 41 Barry
7,0 39 Stephen
*/
void fractionalRank(const int[string] data) {
    writeln("Fractional Rank");

    int rank = 0;
    foreach (value; data.values.dup.sort!"a>b".uniq) {
        real avg = 0;
        int cnt;

        foreach(k,v; data) {
            if (v==value) {
                rank++;
                cnt++;
                avg+=rank;
            }
        }
        avg /= cnt;

        foreach(k,v; data) {
            if (v==value) {
                writef("%0.1f ", avg);
                writeln(v, " ", k);
            }
        }
    }

    writeln;
}
