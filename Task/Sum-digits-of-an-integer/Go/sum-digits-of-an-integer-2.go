// File digit_test.go

package digit

import "testing"

type testCase struct {
	n    string
	base int
	dSum int
}

var testData = []testCase{
	{"1", 10, 1},
	{"1234", 10, 10},
	{"fe", 16, 29},
	{"f0e", 16, 29},
	{"18446744073709551615", 10, 87},
	{"abcdefghijklmnopqrstuvwzuz0123456789", 36, 628},
}

func TestSumString(t *testing.T) {
	for _, tc := range testData {
		ds, err := SumString(tc.n, tc.base)
		if err != nil {
			t.Error("test case", tc, err)
			continue
		}
		if ds != tc.dSum {
			t.Error("test case", tc, "got", ds, "expected", tc.dSum)
		}
	}
}

func TestErrors(t *testing.T) {
	for _, tc := range []struct {
		n    string
		base int
	}{
		{"1234", 37},
		{"0", 1},
		{"1234", 4},
		{"-123", 10},
	} {
		_, err := SumString(tc.n, tc.base)
		if err == nil {
			t.Error("expected error for", tc)
		}
		t.Log("got expected error:", err)
	}
}
