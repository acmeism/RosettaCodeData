#include <iostream>

int circlesort(int* arr, int lo, int hi, int swaps) {
    if(lo == hi) {
        return swaps;
    }
    int high = hi;
    int low = lo;
    int mid = (high - low) / 2;
    while(lo < hi) {
        if(arr[lo] > arr[hi]) {
            int temp = arr[lo];
            arr[lo] = arr[hi];
            arr[hi] = temp;
            swaps++;
        }
        lo++;
        hi--;
    }

    if(lo == hi) {
        if(arr[lo] > arr[hi+1]) {
            int temp = arr[lo];
            arr[lo] = arr[hi+1];
            arr[hi+1] = temp;
            swaps++;
        }
    }
    swaps = circlesort(arr, low, low+mid, swaps);
    swaps = circlesort(arr, low+mid+1, high, swaps);
    return swaps;
}

void circlesortDriver(int* arr, int n) {
    do {
        for(int i = 0; i < n; i++) {
            std::cout << arr[i] << ' ';
        }
        std::cout << std::endl;
    } while(circlesort(arr, 0, n-1, 0));
}

int main() {
    int arr[] = { 6, 7, 8, 9, 2, 5, 3, 4, 1 };
    circlesortDriver(arr, sizeof(arr)/sizeof(int));
    return 0;
}
