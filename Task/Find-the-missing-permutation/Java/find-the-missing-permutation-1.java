import java.util.ArrayList;

import com.google.common.base.Joiner;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;

public class FindMissingPermutation {
	public static void main(String[] args) {
		Joiner joiner = Joiner.on("").skipNulls();
		ImmutableSet<String> s = ImmutableSet.of("ABCD", "CABD", "ACDB",
				"DACB", "BCDA", "ACBD", "ADCB", "CDAB", "DABC", "BCAD", "CADB",
				"CDBA", "CBAD", "ABDC", "ADBC", "BDCA", "DCBA", "BACD", "BADC",
				"BDAC", "CBDA", "DBCA", "DCAB");

		for (ArrayList<Character> cs : Utils.Permutations(Lists.newArrayList(
				'A', 'B', 'C', 'D')))
			if (!s.contains(joiner.join(cs)))
				System.out.println(joiner.join(cs));
	}
}
