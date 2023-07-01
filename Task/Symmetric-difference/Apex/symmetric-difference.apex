Set<String> setA = new Set<String>{'John', 'Bob', 'Mary', 'Serena'};
Set<String> setB = new Set<String>{'Jim', 'Mary', 'John', 'Bob'};

// Option 1
Set<String> notInSetA = setB.clone();
notInSetA.removeAll(setA);

Set<String> notInSetB = setA.clone();
notInSetB.removeAll(setB);

Set<String> symmetricDifference = new Set<String>();
symmetricDifference.addAll(notInSetA);
symmetricDifference.addAll(notInSetB);

// Option 2
Set<String> union = setA.clone();
union.addAll(setB);

Set<String> intersection = setA.clone();
intersection.retainAll(setB);

Set<String> symmetricDifference2 = union.clone();
symmetricDifference2.removeAll(intersection);

System.debug('Not in set A: ' + notInSetA);
System.debug('Not in set B: ' + notInSetB);
System.debug('Symmetric Difference: ' + symmetricDifference);
System.debug('Symmetric Difference 2: ' + symmetricDifference2);
