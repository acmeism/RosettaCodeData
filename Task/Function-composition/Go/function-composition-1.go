// Go doesn't have generics, but sometimes a type definition helps
// readability and maintainability.   This example is written to
// the following function type, which uses float64.
type ffType func(float64) float64

// compose function requested by task
func compose(f, g ffType) ffType {
    return func(x float64) float64 {
        return f(g(x))
    }
}
