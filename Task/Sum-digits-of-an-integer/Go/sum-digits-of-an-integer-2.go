package digit_test

import (
    "testing"

    "digit"
)

type testCase struct {
    n    string
    base int
    dSum int64
}

var testData = []testCase{
    {"1", 10, 1},
    {"1234", 10, 10},
    {"fe", 16, 29},
    {"f0e", 16, 29},
}

func testSum(t *testing.T) {
    for _, tc := range testData {
        ds, err := digit.Sum(tc.n, tc.base)
        if err != nil {
            t.Fatal("test case", tc, err)
        }
        if ds != tc.dSum {
            t.Fatal("test case", tc, "got", ds, "expected", tc.dSum)
        }
    }
}
