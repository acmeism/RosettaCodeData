void triangleC(int nRows) {
    if (nRows <= 0) return;
    int *prevRow = NULL;
    for (int r = 1; r <= nRows; r++) {
        int *currRow = malloc(r * sizeof(int));
        for (int i = 0; i < r; i++) {
            int val = i==0 || i==r-1 ? 1 : prevRow[i-1] + prevRow[i];
            currRow[i] = val;
            printf(" %4d", val);
        }
        printf("\n");
        free(prevRow);
        prevRow = currRow;
    }
    free(prevRow);
}
