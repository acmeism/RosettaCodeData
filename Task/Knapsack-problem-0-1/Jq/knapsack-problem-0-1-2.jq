def objects: [
 {name: "map",                    "weight": 9,   "value": 150},
 {name: "compass",                "weight": 13,  "value": 35},
 {name: "water",                  "weight": 153, "value": 200},
 {name: "sandwich",               "weight": 50,  "value": 160},
 {name: "glucose",                "weight": 15,  "value": 60},
 {name: "tin",                    "weight": 68,  "value": 45},
 {name: "banana",                 "weight": 27,  "value": 60},
 {name: "apple",                  "weight": 39,  "value": 40},
 {name: "cheese",                 "weight": 23,  "value": 30},
 {name: "beer",                   "weight": 52,  "value": 10},
 {name: "suntancream",            "weight": 11,  "value": 70},
 {name: "camera",                 "weight": 32,  "value": 30},
 {name: "T-shirt",                "weight": 24,  "value": 15},
 {name: "trousers",               "weight": 48,  "value": 10},
 {name: "umbrella",               "weight": 73,  "value": 40},
 {name: "waterproof trousers",    "weight": 42,  "value": 70},
 {name: "waterproof overclothes", "weight": 43,  "value": 75},
 {name: "note-case",              "weight": 22,  "value": 80},
 {name: "sunglasses",             "weight": 7,   "value": 20},
 {name: "towel",                  "weight": 18,  "value": 12},
 {name: "socks",                  "weight": 4,   "value": 50},
 {name: "book",                   "weight": 30,  "value": 10}
];

objects | dynamic_knapsack(400)[]
