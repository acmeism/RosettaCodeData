$ time jq -n -f zebra.jq
[
  {
    "number": 0,
    "nation": "norwegian",
    "color": "yellow",
    "smokes": "Dunhill",
    "owns": "cats",
    "drinks": "water"
  },
  {
    "number": 1,
    "drinks": "tea",
    "nation": "dane",
    "smokes": "Blend",
    "owns": "horse",
    "color": "blue"
  },
  {
    "number": 2,
    "drinks": "milk",
    "color": "red",
    "nation": "englishman",
    "owns": "birds",
    "smokes": "Pall Mall"
  },
  {
    "number": 3,
    "color": "green",
    "drinks": "coffee",
    "nation": "german",
    "smokes": "Prince",
    "owns": "zebra"
  },
  {
    "number": 4,
    "nation": "swede",
    "owns": "dog",
    "color": "white",
    "drinks": "beer",
    "smokes": "Blue Master"
  }
]

# Times include compilation:
real	0m0.284s
user	0m0.260s
sys	0m0.005s
