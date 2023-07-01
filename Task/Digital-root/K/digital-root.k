/ print digital root and additive persistence
prt: {`"Digital root = ", x, `"Additive persistence = ",y}
/ sum of digits of an integer
sumdig: {d::(); (0<){d::d,x!10; x%:10}/x; +/d}
/ compute digital root and additive persistence
digroot: {sm::sumdig x; ap::0; (9<){sm::sumdig x;ap::ap+1; x:sm}/x; prt[sm;ap]}
