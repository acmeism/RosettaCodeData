<min-heap> [ {
    { 3 "Clear drains" }
    { 4 "Feed cat" }
    { 5 "Make tea" }
    { 1 "Solve RC tasks" }
    { 2 "Tax return" }
  } swap heap-push-all
] [
  [ print ] slurp-heap
] bi
