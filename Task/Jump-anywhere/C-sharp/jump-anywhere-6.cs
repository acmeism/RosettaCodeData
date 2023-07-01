public int M(int n) {
    int result = 0;
    switch (n) {
        case 1:
            cost += 25;
            break;
        case 2:
            cost += 25;
            goto case 1;
        case 3:
            cost += 50;
            goto case 1;
    }
    return result;
}
