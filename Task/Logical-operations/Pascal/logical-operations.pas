function logicalOperations(A, B: Boolean): Boolean;
begin
	{ logical conjunction }
	writeLn(A:5, ' and', B:6, '  yields', A and B:7);
	{ logical disjunction }
	writeLn(A:5, '  or', B:6, '  yields',  A or B:7);
	{ logical negation }
	writeLn('      not', A:6, '  yields',   not A:7);
	{ logical equivalence }
	writeLn(A:5, '   =', B:6, '  yields',   A = B:7);
	{ negation of logical equivalence }
	writeLn(A:5, '  <>', B:6, '  yields',  A <> B:7);
	{ relational operators }
	writeLn(A:5, '   <', B:6, '  yields',   A < B:7);
	writeLn(A:5, '   >', B:6, '  yields',   A > B:7);
	writeLn(A:5, '  <=', B:6, '  yields',  A <= B:7);
	writeLn(A:5, '  >=', B:6, '  yields',  A >= B:7);
	{ fulfill task requirement of writing a function: }
	logicalOperations := true
end;
