sub permutations-with-some-identical-elements ( @elements, @reps = () ) {
    with @elements { (@reps ?? flat $_ Zxx @reps !! flat .keys.map(*+1) Zxx .values).permutations».join.unique }
 }

for (<2 1>,), (<2 3 1>,), (<A B C>, <2 3 1>), (<🦋 ⚽ 🙄>, <2 2 1>) {
    put permutations-with-some-identical-elements |$_;
    say '';
}
