#include <iostream>
#include <vector>

using namespace std;

void shift_down(vector<int>& heap,int i, int max) {
    int i_big, c1, c2;
    while(i < max) {
        i_big = i;
        c1 = (2*i) + 1;
        c2 = c1 + 1;
        if( c1<max && heap[c1]>heap[i_big] )
            i_big = c1;
        if( c2<max && heap[c2]>heap[i_big] )
            i_big = c2;
        if(i_big == i) return;
        swap(heap[i],heap[i_big]);
        i = i_big;
    }
}

void to_heap(vector<int>& arr) {
    int i = (arr.size()/2) - 1;
    while(i >= 0) {
        shift_down(arr, i, arr.size());
        --i;
    }
}

void heap_sort(vector<int>& arr) {
    to_heap(arr);
    int end = arr.size() - 1;
    while (end > 0) {
        swap(arr[0], arr[end]);
        shift_down(arr, 0, end);
        --end;
    }
}

int main() {
    vector<int> data = {
        12, 11, 15, 10, 9, 1, 2,
        3, 13, 14, 4, 5, 6, 7, 8
    };
    heap_sort(data);
    for(int i : data) cout << i << " ";
}
