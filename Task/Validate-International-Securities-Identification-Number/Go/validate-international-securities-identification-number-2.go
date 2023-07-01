package main

import "testing"

func TestValidISIN(t *testing.T) {
	testcases := []struct {
		isin  string
		valid bool
	}{
		{"US0378331005", true},
		{"US0373831005", false},
		{"U50378331005", false},
		{"US03378331005", false},
		{"AU0000XVGZA3", true},
		{"AU0000VXGZA3", true},
		{"FR0000988040", true},
	}

	for _, testcase := range testcases {
		actual := ValidISIN(testcase.isin)
		if actual != testcase.valid {
			t.Errorf("expected %v for %q, got %v",
				testcase.valid, testcase.isin, actual)
		}
	}
}
