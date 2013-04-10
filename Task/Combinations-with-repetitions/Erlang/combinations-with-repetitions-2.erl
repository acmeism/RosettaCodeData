94> comb:comb_rep(2,[iced,jam,plain]).
[[iced,iced],
 [iced,jam],
 [iced,plain],
 [jam,jam],
 [jam,plain],
 [plain,plain]]
95> length(comb:comb_rep(3,lists:seq(1,10))).
220
