interface IntToVoid {
    void run(int x);
}

for (int z : myIntArray) {
    new IntToVoid() {
        public void run(int x) {
            System.out.println(x);
        }
    }.run(z);
}
