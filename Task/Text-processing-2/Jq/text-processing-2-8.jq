$ jq -R  '[splits("[ \t]+")]' readings.txt | jq -s -r -f  Text_processing_2.jq
Checking for duplicate timestamps:
[
  [
    "1990-03-25",
    2
  ],
  [
    "1991-03-31",
    2
  ],
  [
    "1992-03-29",
    2
  ],
  [
    "1993-03-28",
    2
  ],
  [
    "1995-03-26",
    2
  ]
]

There are 5017 valid rows altogether.
