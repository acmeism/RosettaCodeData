use std::cmp;

struct Item {
    name: &'static str,
    weight: usize,
    value: usize
}

fn knapsack01_dyn(items: &[Item], max_weight: usize) -> Vec<&Item> {
    let mut best_value = vec![vec![0; max_weight + 1]; items.len() + 1];
    for (i, it) in items.iter().enumerate() {
        for w in 1 .. max_weight + 1 {
            best_value[i + 1][w] =
                if it.weight > w {
                    best_value[i][w]
                } else {
                    cmp::max(best_value[i][w], best_value[i][w - it.weight] + it.value)
                }
        }
    }

    let mut result = Vec::with_capacity(items.len());
    let mut left_weight = max_weight;

    for (i, it) in items.iter().enumerate().rev() {
        if best_value[i + 1][left_weight] != best_value[i][left_weight] {
            result.push(it);
            left_weight -= it.weight;
        }
    }

    result
}


fn main () {
    const MAX_WEIGHT: usize = 400;

    const ITEMS: &[Item] = &[
        Item { name: "map",                    weight: 9,   value: 150 },
        Item { name: "compass",                weight: 13,  value: 35 },
        Item { name: "water",                  weight: 153, value: 200 },
        Item { name: "sandwich",               weight: 50,  value: 160 },
        Item { name: "glucose",                weight: 15,  value: 60 },
        Item { name: "tin",                    weight: 68,  value: 45 },
        Item { name: "banana",                 weight: 27,  value: 60 },
        Item { name: "apple",                  weight: 39,  value: 40 },
        Item { name: "cheese",                 weight: 23,  value: 30 },
        Item { name: "beer",                   weight: 52,  value: 10 },
        Item { name: "suntancream",            weight: 11,  value: 70 },
        Item { name: "camera",                 weight: 32,  value: 30 },
        Item { name: "T-shirt",                weight: 24,  value: 15 },
        Item { name: "trousers",               weight: 48,  value: 10 },
        Item { name: "umbrella",               weight: 73,  value: 40 },
        Item { name: "waterproof trousers",    weight: 42,  value: 70 },
        Item { name: "waterproof overclothes", weight: 43,  value: 75 },
        Item { name: "note-case",              weight: 22,  value: 80 },
        Item { name: "sunglasses",             weight: 7,   value: 20 },
        Item { name: "towel",                  weight: 18,  value: 12 },
        Item { name: "socks",                  weight: 4,   value: 50 },
        Item { name: "book",                   weight: 30,  value: 10 }
    ];

    let items = knapsack01_dyn(ITEMS, MAX_WEIGHT);

    // We reverse the order because we solved the problem backward.
    for it in items.iter().rev() {
        println!("{}", it.name);
    }

    println!("Total weight: {}", items.iter().map(|w| w.weight).sum::<usize>());
    println!("Total value: {}", items.iter().map(|w| w.value).sum::<usize>());
}
