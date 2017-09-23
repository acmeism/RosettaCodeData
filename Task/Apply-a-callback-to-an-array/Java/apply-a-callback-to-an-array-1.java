public class ArrayCallback7 {

    interface IntConsumer {
        void run(int x);
    }

    interface IntToInt {
        int run(int x);
    }

    static void forEach(int[] arr, IntConsumer consumer) {
        for (int i : arr) {
            consumer.run(i);
        }
    }

    static void update(int[] arr, IntToInt mapper) {
        for (int i = 0; i < arr.length; i++) {
            arr[i] = mapper.run(arr[i]);
        }
    }

    public static void main(String[] args) {
        int[] numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

        forEach(numbers, new IntConsumer() {
            public void run(int x) {
                System.out.println(x);
            }
        });

        update(numbers, new IntToInt() {
            @Override
            public int run(int x) {
                return x * x;
            }
        });

        forEach(numbers, new IntConsumer() {
            public void run(int x) {
                System.out.println(x);
            }
        });
    }
}
