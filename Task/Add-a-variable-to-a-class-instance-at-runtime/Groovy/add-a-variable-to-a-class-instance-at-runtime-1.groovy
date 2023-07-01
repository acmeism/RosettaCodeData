class A {
    final x = { it + 25 }
    private map = new HashMap()
    Object get(String key) { map[key] }
    void set(String key, Object value) { map[key] = value }
}
