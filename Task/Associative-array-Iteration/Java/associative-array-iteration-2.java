Map<String, Integer> myDict = new HashMap<>();
myDict.put("hello", 1);
myDict.put("world", 2);
myDict.put("!", 3);

// iterating over key-value pairs:
myDict.forEach((k, v) -> {
    System.out.printf("key = %s, value = %s%n", k, v);
});

// iterating over keys:
myDict.keySet().forEach(k -> System.out.printf("key = %s%n", k));

// iterating over values:
myDict.values().forEach(v -> System.out.printf("value = %s%n", v));
