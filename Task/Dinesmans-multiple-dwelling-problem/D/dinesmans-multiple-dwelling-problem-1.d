import std.stdio, std.math, std.algorithm, std.traits, std.array, permutations2:permutations;

void main() {

    enum Names { Baker, Cooper, Fletcher, Miller, Smith }

    immutable(bool function(in Names[]) pure nothrow)[] predicates = [
			s => s.countUntil(Names.Baker) != 4 && s.countUntil(Names.Cooper)  != 0,
			s => s.countUntil(Names.Fletcher) != 4 && s.countUntil(Names.Fletcher) != 0,
			s => s.countUntil(Names.Miller) > s.countUntil(Names.Cooper),
			s => abs(s.countUntil(Names.Smith) - s.countUntil(Names.Fletcher)) != 1,
			s => abs(s.countUntil(Names.Cooper) - s.countUntil(Names.Fletcher)) != 1
		];
	
    permutations([EnumMembers!Names]).filter!(solution => predicates.all!(pred => pred(solution)))
    .writeln;
	
}
