Map<String, Integer> map = new HashMap<String, Integer>();
map.put("hello", 1);
map.put("world", 2);
map.put("!", 3);

// iterating over key-value pairs:
for (Map.Entry<String, Integer> e : map.entrySet()) {
    String key = e.getKey();
    Integer value = e.getValue();
    System.out.println("key = " + key + ", value = " + value);
}

// iterating over keys:
for (String key : map.keySet()) {
    System.out.println("key = " + key);
}

// iterating over values:
for (Integer value : map.values()) {
    System.out.println("value = " + value);
}
