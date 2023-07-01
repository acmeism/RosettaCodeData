compassangle(1, 'North',n, 0.00).
compassangle(2, 'North by east', nbe, 11.25).
compassangle(3, 'North-northeast', nne,22.50).
compassangle(4, 'Northeast by north', nebn,33.75).
compassangle(5, 'Northeast', ne,45.00).
compassangle(6, 'Norteast by east', nebe,56.25).
compassangle(7, 'East-northeast', ene,67.50).
compassangle(8, 'East by North', ebn,78.75).
compassangle(9, 'East', e,90.00).
compassangle(10, 'East by south', ebs, 101.25).
compassangle(11, 'East-southeast', ese,112.50).
compassangle(12, 'Southeast by east', sebe, 123.75).
compassangle(13, 'Southeast', se, 135.00).
compassangle(14, 'Southeast by south', sebs, 146.25).
compassangle(15, 'South-southeast',sse, 157.50).
compassangle(16, 'South by east', sbe, 168.75).
compassangle(17, 'South', s, 180.00).
compassangle(18, 'South by west', sbw, 191.25).
compassangle(19, 'South-southwest', ssw, 202.50).
compassangle(20, 'Southwest by south', swbs, 213.75).
compassangle(21, 'Southwest', sw, 225.00).
compassangle(22, 'Southwest by west', swbw, 236.25).
compassangle(23, 'West-southwest', wsw, 247.50).
compassangle(24, 'West by south', wbs, 258.75).
compassangle(25, 'West', w, 270.00).
compassangle(26, 'West by north', wbn, 281.25).
compassangle(27, 'West-northwest', wnw, 292.50).
compassangle(28, 'Northwest by west', nwbw, 303.75).
compassangle(29, 'Northwest', nw, 315.00).
compassangle(30, 'Northwest by north', nwbn, 326.25).
compassangle(31, 'North-northwest', nnw, 337.50).
compassangle(32, 'North by west', nbw, 348.75).
compassangle(1, 'North', n, 360.00).
compassangle(Index , Name, Heading, Angle) :- nonvar(Angle), resolveindex(Angle, Index),
                                               compassangle(Index,Name, Heading, _).

resolveindex(Angle, Index) :- N is Angle / 11.25 + 0.5, I is floor(N),Index is (I mod 32) + 1.
