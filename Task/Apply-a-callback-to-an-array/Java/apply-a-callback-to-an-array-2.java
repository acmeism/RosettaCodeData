interface IntToInt {
    int run(int x);
}

int[] result = new int[myIntArray.length];
for (int i = 0; i < myIntArray.length; i++) {
    result[i] =
        new IntToInt() {
            public int run(int x) {
                return x * x;
            }
        }.run(myIntArray[i]);
}
