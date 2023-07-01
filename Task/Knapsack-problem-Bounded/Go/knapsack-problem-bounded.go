package main

import "fmt"

type Item struct {
	name               string
	weight, value, qty int
}

var items = []Item{
	{"map",			9,	150,	1},
	{"compass",		13,	35,	1},
	{"water",		153,	200,	2},
	{"sandwich",		50,	60,	2},
	{"glucose",		15,	60,	2},
	{"tin",			68,	45,	3},
	{"banana",		27,	60,	3},
	{"apple",		39,	40,	3},
	{"cheese",		23,	30,	1},
	{"beer",		52,	10,	3},
	{"suntancream",		11,	70,	1},
	{"camera",		32,	30,	1},
	{"T-shirt",		24,	15,	2},
	{"trousers",		48,	10,	2},
	{"umbrella",		73,	40,	1},
	{"w-trousers",		42,	70,	1},
	{"w-overclothes",	43,	75,	1},
	{"note-case",		22,	80,	1},
	{"sunglasses",		7,      20,	1},
	{"towel",		18,	12,	2},
	{"socks",		4,      50,	1},
	{"book",		30,	10,	2},
}

type Chooser struct {
	Items []Item
	cache map[key]solution
}

type key struct {
	w, p int
}

type solution struct {
	v, w int
	qty  []int
}

func (c Chooser) Choose(limit int) (w, v int, qty []int) {
	c.cache = make(map[key]solution)
	s := c.rchoose(limit, len(c.Items)-1)
	c.cache = nil // allow cache to be garbage collected
	return s.v, s.w, s.qty
}

func (c Chooser) rchoose(limit, pos int) solution {
	if pos < 0 || limit <= 0 {
		return solution{0, 0, nil}
	}

	key := key{limit, pos}
	if s, ok := c.cache[key]; ok {
		return s
	}

	best_i, best := 0, solution{0, 0, nil}
	for i := 0; i*items[pos].weight <= limit && i <= items[pos].qty; i++ {
		sol := c.rchoose(limit-i*items[pos].weight, pos-1)
		sol.v += i * items[pos].value
		if sol.v > best.v {
			best_i, best = i, sol
		}
	}

	if best_i > 0 {
		// best.qty is used in another cache entry,
		// we need to duplicate it before modifying it to
		// store as our cache entry.
		old := best.qty
		best.qty = make([]int, len(items))
		copy(best.qty, old)
		best.qty[pos] = best_i
		best.w += best_i * items[pos].weight
	}
	c.cache[key] = best
	return best
}

func main() {
	v, w, s := Chooser{Items: items}.Choose(400)

	fmt.Println("Taking:")
	for i, t := range s {
		if t > 0 {
			fmt.Printf("  %d of %d %s\n", t, items[i].qty, items[i].name)
		}
	}
	fmt.Printf("Value: %d; weight: %d\n", v, w)
}
