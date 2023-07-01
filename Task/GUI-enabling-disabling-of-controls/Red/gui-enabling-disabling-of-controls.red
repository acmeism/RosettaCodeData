Red[]

enable: does [
    f/enabled?: 0 = n
    i/enabled?: 10 > n
    d/enabled?: 0 < n
]

view [
    f: field "0" [either error? try [n: to-integer f/text] [f/text: "0"] [enable]]
    i: button "increment" [f/text: mold n: add to-integer f/text 1 enable]
    d: button "decrement" disabled [f/text: mold n: subtract to-integer f/text 1 enable]
]
