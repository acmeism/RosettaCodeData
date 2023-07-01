type cell string

type spec struct {
    less     func(cell, cell) bool
    column   int
    reverse  bool
}

func newSpec() (s spec) {
    // initialize any defaults
    return
}

// sort with all defaults
t.sort(newSpec())

// reverse sort
s := newSpec
s.reverse = true
t.sort(s)
