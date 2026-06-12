package main

import (
	"fmt"
	"math/bits"
	"sort"
)

// BitRank is a rank data structure for bit vectors
type BitRank struct {
	block []uint64
	count []int
}

// Resize resizes the bit vector to the given length
func (br *BitRank) Resize(num int) {
	br.block = make([]uint64, (num+1)>>6+1)
	br.count = make([]int, len(br.block))
}

// Set sets bit at position i
func (br *BitRank) Set(i int, val int) {
	if val == 1 {
		br.block[i>>6] |= (1 << uint(i&63))
	}
}

// Build builds the rank structure
func (br *BitRank) Build() {
	for i := 1; i < len(br.block); i++ {
		br.count[i] = br.count[i-1] + br.popcountll(br.block[i-1])
	}
}

// popcountll counts number of 1's in a 64-bit integer
func (br *BitRank) popcountll(n uint64) int {
	return bits.OnesCount64(n)
}

// Rank1 counts number of 1's in [0, i)
func (br *BitRank) Rank1(i int) int {
	return br.count[i>>6] +
		br.popcountll(br.block[i>>6]&((1<<uint(i&63))-1))
}

// Rank1FromTo counts number of 1's in [i, j)
func (br *BitRank) Rank1FromTo(i, j int) int {
	return br.Rank1(j) - br.Rank1(i)
}

// Rank0 counts number of 0's in [0, i)
func (br *BitRank) Rank0(i int) int {
	return i - br.Rank1(i)
}

// Rank0FromTo counts number of 0's in [i, j)
func (br *BitRank) Rank0FromTo(i, j int) int {
	return br.Rank0(j) - br.Rank0(i)
}

// WaveletMatrix is a wavelet matrix data structure
type WaveletMatrix struct {
	height int
	B      []*BitRank
	pos    []int
}

// NewWaveletMatrix creates a new wavelet matrix
func NewWaveletMatrix(vec []int, sigma ...int) *WaveletMatrix {
	wm := &WaveletMatrix{}
	
	s := 0
	if len(sigma) > 0 {
		s = sigma[0]
	} else {
		// Find the maximum element and use that as sigma
		for _, v := range vec {
			if v > s {
				s = v
			}
		}
		s++
	}
	
	wm.init(vec, s)
	return wm
}

func (wm *WaveletMatrix) init(vec []int, sigma int) {
	// Calculate height based on sigma value
	if sigma == 1 {
		wm.height = 1
	} else {
		wm.height = 64 - bits.LeadingZeros(uint(sigma-1))
	}
	
	wm.B = make([]*BitRank, wm.height)
	wm.pos = make([]int, wm.height)
	
	for i := 0; i < wm.height; i++ {
		wm.B[i] = &BitRank{}
		wm.B[i].Resize(len(vec))
		
		for j := 0; j < len(vec); j++ {
			wm.B[i].Set(j, wm.get(vec[j], wm.height-i-1))
		}
		
		wm.B[i].Build()
		
		// Stable partition - separate 0's and 1's while preserving order
		wm.pos[i] = wm.stablePartition(vec, func(c int) bool {
			return wm.get(c, wm.height-i-1) == 0
		})
	}
}

// stablePartition is equivalent to C++ stable_partition
func (wm *WaveletMatrix) stablePartition(arr []int, predicate func(int) bool) int {
	result := make([]int, 0, len(arr))
	falseValues := make([]int, 0, len(arr))
	
	for _, item := range arr {
		if predicate(item) {
			result = append(result, item)
		} else {
			falseValues = append(falseValues, item)
		}
	}
	
	partitionPoint := len(result)
	result = append(result, falseValues...)
	
	// Update the original array
	copy(arr, result)
	
	return partitionPoint
}

// get returns bit at position i from val
func (wm *WaveletMatrix) get(val, i int) int {
	return (val >> i) & 1
}

// Rank counts occurrences of val in range [l, r)
func (wm *WaveletMatrix) Rank(val, l, r int) int {
	return wm.RankSingle(val, r) - wm.RankSingle(val, l)
}

// RankSingle counts occurrences of val in range [0, i)
func (wm *WaveletMatrix) RankSingle(val, i int) int {
	p := 0
	for j := 0; j < wm.height; j++ {
		if wm.get(val, wm.height-j-1) == 1 {
			p = wm.pos[j] + wm.B[j].Rank1(p)
			i = wm.pos[j] + wm.B[j].Rank1(i)
		} else {
			p = wm.B[j].Rank0(p)
			i = wm.B[j].Rank0(i)
		}
	}
	return i - p
}

// Quantile returns kth smallest element in [l, r)
func (wm *WaveletMatrix) Quantile(k, l, r int) int {
	res := 0
	for i := 0; i < wm.height; i++ {
		j := wm.B[i].Rank0FromTo(l, r)
		if j > k {
			l = wm.B[i].Rank0(l)
			r = wm.B[i].Rank0(r)
		} else {
			l = wm.pos[i] + wm.B[i].Rank1(l)
			r = wm.pos[i] + wm.B[i].Rank1(r)
			k -= j
			res |= (1 << (wm.height - i - 1))
		}
	}
	return res
}

// RangeFreq counts elements in [l, r) that are in value range [a, b)
func (wm *WaveletMatrix) RangeFreq(l, r, a, b int) int {
	return wm.rangeFreqRecursive(l, r, a, b, 0, 1<<wm.height, 0)
}

func (wm *WaveletMatrix) rangeFreqRecursive(i, j, a, b, l, r, x int) int {
	if i == j || r <= a || b <= l {
		return 0
	}
	
	mid := (l + r) >> 1
	if a <= l && r <= b {
		return j - i
	} else {
		left := wm.rangeFreqRecursive(
			wm.B[x].Rank0(i),
			wm.B[x].Rank0(j),
			a, b, l, mid, x+1,
		)
		right := wm.rangeFreqRecursive(
			wm.pos[x]+wm.B[x].Rank1(i),
			wm.pos[x]+wm.B[x].Rank1(j),
			a, b, mid, r, x+1,
		)
		return left + right
	}
}

// RangeMin finds minimum value in [l, r) within value range [a, b), -1 if not found
func (wm *WaveletMatrix) RangeMin(l, r, a, b int) int {
	return wm.rangeMinRecursive(l, r, a, b, 0, 1<<wm.height, 0, 0)
}

func (wm *WaveletMatrix) rangeMinRecursive(i, j, a, b, l, r, x, val int) int {
	if i == j || r <= a || b <= l {
		return -1
	}
	if r-l == 1 {
		return val
	}
	
	mid := (l + r) >> 1
	res := wm.rangeMinRecursive(
		wm.B[x].Rank0(i),
		wm.B[x].Rank0(j),
		a, b, l, mid, x+1, val,
	)
	
	if res < 0 {
		return wm.rangeMinRecursive(
			wm.pos[x]+wm.B[x].Rank1(i),
			wm.pos[x]+wm.B[x].Rank1(j),
			a, b, mid, r, x+1,
			val+(1<<(wm.height-x-1)),
		)
	} else {
		return res
	}
}

// binary search to find index in sorted array
func find(arr []int, x int) int {
	left := 0
	right := len(arr)
	for left < right {
		mid := (left + right) / 2
		if arr[mid] < x {
			left = mid + 1
		} else {
			right = mid
		}
	}
	return left
}

func main() {
	n := 5
	a := []int{3374, 956, 2114, 3415, 3437}
	
	input := make([]int, n)
	copy(input, a)
	backup := make([]int, n)
	copy(backup, a)
	
	// Sort and deduplicate the array
	sortedA := make([]int, n)
	copy(sortedA, a)
	sort.Ints(sortedA)
	
	// Deduplicate
	uniqueA := []int{}
	for i, val := range sortedA {
		if i == 0 || val != sortedA[i-1] {
			uniqueA = append(uniqueA, val)
		}
	}
	
	// Map original values to their indices in the unique array
	for i := 0; i < n; i++ {
		input[i] = find(uniqueA, backup[i])
	}
	
	lrkVector := [][]int{
		{2, 2, 1},
		{3, 4, 1},
		{4, 5, 1},
		{1, 2, 2},
		{4, 4, 1},
	}
	
	wm := NewWaveletMatrix(input)
	
	for _, lrk := range lrkVector {
		l, r, k := lrk[0], lrk[1], lrk[2]
		l-- // Convert to 0-indexed
		fmt.Println(uniqueA[wm.Quantile(k-1, l, r)])
	}
}
