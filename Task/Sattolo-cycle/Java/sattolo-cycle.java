private static final Random rng = new Random();

void sattoloCycle(Object[] items) {
    for (int i = items.length-1; i > 0; i--) {
        int j = rng.nextInt(i);
        Object tmp = items[i];
        items[i] = items[j];
        items[j] = tmp;
    }
}
