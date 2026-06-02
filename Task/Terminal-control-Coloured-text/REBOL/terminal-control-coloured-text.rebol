;; Using predefined functions:
str: "Hello World"
print as-gray str
print as-red str
print as-green str
print as-yellow str
print as-blue str
print as-purple str
print as-cyan str
print as-white str
;; Manually:
red:   "^[[31m"
reset: "^[[0m"
print ajoin ["Hello " red "World" reset]
