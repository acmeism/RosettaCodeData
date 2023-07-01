List<String> listA = new List<String> { 'apple' };
List<String> listB = new List<String> { 'banana' };
listA.addAll(listB);
System.debug(listA); // Prints (apple, banana)
