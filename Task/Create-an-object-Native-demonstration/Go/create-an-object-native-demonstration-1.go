package romap

type Romap struct{ imap map[byte]int }

//  Create new read-only wrapper for the given map.
func New(m map[byte]int) *Romap {
    if m == nil {
        return nil
    }
    return &Romap{m}
}

// Retrieve value for a given key, if it exists.
func (rom *Romap) Get(key byte) (int, bool) {
    i, ok := rom.imap[key]
    return i, ok
}

// Reset value for a given key, if it exists.
func (rom *Romap) Reset(key byte) {
    _, ok := rom.imap[key]
    if ok {
        rom.imap[key] = 0 // default value of int
    }
}
