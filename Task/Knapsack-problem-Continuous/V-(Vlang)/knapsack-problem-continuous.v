struct Item {
    item string
    weight f64
    price f64
}

fn main(){
    mut left := 15.0
    mut items := [
        Item{'beef', 3.8, 36},
        Item{'pork', 5.4, 43},
        Item{'ham', 3.6, 90},
        Item{'greaves', 2.4, 45},
        Item{'flitch', 4.0, 30},
        Item{'brawn', 2.5, 56},
        Item{'welt', 3.7, 67},
        Item{'salami', 3.0, 95},
        Item{'sausage', 5.9, 98}
    ]
    items.sort_with_compare(fn (a &Item, b &Item) int {
        if a.weight/a.price < b.weight/b.price {
            return -1
        } else if a.weight/a.price > b.weight/b.price {
            return 1
        } else {
            return 0
        }
    })
    for item in items {
        if item.weight <= left {
            println('Take all the $item.item')
            if item.weight == left {
                return
            }
            left -= item.weight
        } else {
            println('Take ${left:.1}kg $item.item')
            return
        }
    }
    //println(items)
}
