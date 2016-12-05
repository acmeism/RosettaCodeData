<String|Integer>[] data = [1, 2, 3, "a", "b", "c", 2, 3, 4, "b", "c", "d"];
<String|Integer>[] unique = HashSet { *data }.sequence();
