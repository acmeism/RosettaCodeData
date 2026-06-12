import "./ioutil" for Input

var prev = Input.number("")
var count = 1
while (true) {
    var next = (prev + 3) * 0.86
    if (prev == next) break
    System.print(prev = next)
    count = count + 1
}
System.print("Took %(count) iterations.")
