// Radix sort comparator for 32-bit two's complement integers
class RadixTest {
  constructor(bit) {
    this.bit = bit; // bit position [0..31] to examine
  }

  // function call operator (simulated with a method)
  test(value) {
    if (this.bit === 31) { // sign bit
      return value < 0; // negative int to left partition
    } else {
      return !(value & (1 << this.bit)); // 0 bit to left partition
    }
  }
}

// Helper function to partition an array in place
function partition(arr, start, end, radixTest) {
  let i = start - 1;

  for (let j = start; j < end; j++) {
    if (radixTest.test(arr[j])) {
      i++;
      // Swap arr[i] and arr[j]
      [arr[i], arr[j]] = [arr[j], arr[i]];
    }
  }
  return i + 1;
}

// Least significant digit radix sort
function lsdRadixSort(arr) {
  for (let lsb = 0; lsb < 32; ++lsb) { // least-significant-bit
    const radixTest = new RadixTest(lsb);
    partition(arr, 0, arr.length, radixTest);
  }
}

// Most significant digit radix sort (recursive)
function msdRadixSort(arr, start = 0, end = arr.length, msb = 31) {
  if (start < end -1 && msb >= 0) {  // changed (first != last)  to (start < end-1) for easier indexing
    const radixTest = new RadixTest(msb);
    let mid = partition(arr, start, end, radixTest);
    msb--; // decrement most-significant-bit
    msdRadixSort(arr, start, mid, msb); // sort left partition
    msdRadixSort(arr, mid, end, msb); // sort right partition
  }
}

// test radix_sort
function main() {
  let data = [170, 45, 75, -90, -802, 24, 2, 66];

  lsdRadixSort(data);
  // msdRadixSort(data);

  console.log(data.join(" "));
}

main();
