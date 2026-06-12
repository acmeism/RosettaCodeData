void main() {
    double pow = 1;
    for (int p = 0; p < 5; ++p) {
        int low = (int)Math.ceil(Math.sqrt(pow));
        if (low % 2 == 0) ++low;
        pow *= 10;
        int high = (int)Math.floor(Math.sqrt(pow));
        int[] odd_square = {};
        for (int i = low; i <= high; i += 2) odd_square += i * i;
        print(@"$(odd_square.length) odd squares from $(pow/10) to $pow:\n");
        for (int i = 0; i < odd_square.length; ++i) {
            print("%d ", odd_square[i]);
            if ((i + 1) % 10 == 0) print("\n");
        }
        print("\n\n");
    }
}
