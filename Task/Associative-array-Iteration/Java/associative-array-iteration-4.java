Map<String, Integer> map = new HashMap<>();
map.put("hello", 1);
map.put("world", 2);
map.put("!", 3);

// iterating over key-value pairs:
map.forEach((k, v) -> {
    System.out.printf("key = %s, value = %s%n", k, v);
});

// iterating over keys:
map.keySet().forEach(k -> System.out.printf("key = %s%n", k));

// iterating over values:
map.values().forEach(v -> System.out.printf("value = %s%n", v));
