struct Item {
    name string
    w int
    v int
}

const wants = [
        Item{'map', 9, 150},
        Item{'compass', 13, 35},
        Item{'water', 153, 200},
        Item{'sandwich', 50, 60},
        Item{'glucose', 15, 60},
        Item{'tin', 68, 45},
        Item{'banana', 27, 60},
        Item{'apple', 39, 40},
        Item{'cheese', 23, 30},
        Item{'beer', 52, 10},
        Item{'suntancream', 11, 70},
        Item{'camera', 32, 30},
        Item{'T-shirt', 24, 15},
        Item{'trousers', 48, 10},
        Item{'umbrella', 73, 40},
        Item{'w-trousers', 42, 70},
        Item{'w-overclothes', 43, 75},
        Item{'note-case', 22, 80},
        Item{'sunglasses', 7, 20},
        Item{'towel', 18, 12},
        Item{'socks', 4, 50},
        Item{'book', 30, 10}
    ]
const max_wt = 400

fn main(){
    items, w, v := m(wants.len-1, max_wt)

    println(items)
    println('weight: $w')
    println('value: $v')
}

fn m(i int, w int) ([]string, int, int) {
    if i<0 || w==0{
        return []string{}, 0, 0
    } else if wants[i].w > w {
        return m(i-1, w)
    }
    i0, w0, v0 := m(i-1, w)
    mut i1, w1, mut v1 := m(i-1, w-wants[i].w)
    v1 += wants[i].v
    if v1 > v0 {
        i1 << wants[i].name
        return i1, w1+wants[i].w, v1
    }
    return i0, w0, v0
}
