Rebol [
    title: "Rosetta code: Search a list of records"
    file:  %Search_a_list_of_records.r3
    url:   https://rosettacode.org/wiki/Search_a_list_of_records
]

index-where: func [
    "Returns the index of the first item matching a condition"
    data      [block!]
    condition [block!]
][
    foreach [pos: item] data [
        if attempt bind condition 'item [return index? pos]
    ]
]

first-where: func [
    "Returns the first truthy result of condition applied to each item"
    data      [block!]
    condition [block!]
    /local result
][
    foreach [pos: item] data [
        if result: attempt bind condition 'item [return result]
    ]
]

data: decode 'json {[
  { "name": "Lagos",                "population": 21.0  },
  { "name": "Cairo",                "population": 15.2  },
  { "name": "Kinshasa-Brazzaville", "population": 11.3  },
  { "name": "Greater Johannesburg", "population":  7.55 },
  { "name": "Mogadishu",            "population":  5.85 },
  { "name": "Khartoum-Omdurman",    "population":  4.98 },
  { "name": "Dar Es Salaam",        "population":  4.7  },
  { "name": "Alexandria",           "population":  4.58 },
  { "name": "Abidjan",              "population":  4.4  },
  { "name": "Casablanca",           "population":  3.98 }
]}

print [
    "^/Index of specific city (Dar Es Salaam):   "
    as-green index-where data [item/name == "Dar Es Salaam"]
    "^/First city below 5M:                      "
    as-green first-where data [if item/population < 5.0 [item/name]]
    "^/Population of first city starting with A: "
    as-green first-where data [if item/name/1 == #"A" [item/population]]
]
