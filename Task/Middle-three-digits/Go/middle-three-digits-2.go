package m3_test

import (
    "testing"

    "m3"
)

func TestPassing(t *testing.T) {
    type s struct {
        i int
        m string
    }
    tcs := []s{
        {123, "123"},
        {12345, "234"},
        {1234567, "345"},
        {987654321, "654"},
        {10001, "000"},
        {-10001, "000"},
    }
    for _, tc := range tcs {
        m, err := m3.Digits(tc.i)
        if err != nil {
            t.Fatalf("d(%d) returned %q.", tc.i, err)
        }
        if m != tc.m {
            t.Fatalf("d(%d) expected %q, got %q.", tc.i, tc.m, m)
        }
        t.Logf("d(%d) = %q.", tc.i, m)
    }
}

func TestFailing(t *testing.T) {
    type s struct {
        i   int
        err error
    }
    tcs := []s{
        {1, m3.ErrorLT3},
        {2, m3.ErrorLT3},
        {-1, m3.ErrorLT3},
        {-10, m3.ErrorLT3},
        {2002, m3.ErrorEven},
        {-2002, m3.ErrorEven},
        {0, m3.ErrorLT3},
    }
    for _, tc := range tcs {
        m, err := m3.Digits(tc.i)
        if err == nil {
            t.Fatal("d(%d) expected error %q, got non-error %q.",
                tc.i, tc.err, m)
        }
        if err != tc.err {
            t.Fatal("d(d) expected error %q, got %q", tc.i, tc.err, err)
        }
        t.Logf("d(%d) returns %q", tc.i, err)
    }
}
