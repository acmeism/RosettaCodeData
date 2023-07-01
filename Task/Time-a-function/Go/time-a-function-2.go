package empty

import "testing"

func BenchmarkEmpty(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Empty()
    }
}

func BenchmarkCount(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Count()
    }
}
