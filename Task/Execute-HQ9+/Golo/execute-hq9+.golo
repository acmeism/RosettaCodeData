module hq9plus

function main = |args| {
  var accumulator = 0
  let source = readln("please enter your source code: ")
  foreach ch in source: chars() {
    case {
      when ch == 'h' or ch == 'H' {
        println("Hello, world!")
      }
      when ch == 'q' or ch == 'Q' {
        println(source)
      }
      when ch == '9' {
        ninety9Bottles()
      }
      when ch == '+' {
        accumulator = accumulator + 1
      }
      otherwise {
        println("syntax error")
      }
    }
  }
}

function bottles = |amount| -> match {
  when amount == 1 then "One bottle"
  when amount == 0 then "No bottles"
  otherwise amount + " bottles"
}

function ninety9Bottles = {
  foreach n in [99..0]: decrementBy(1) {
    println(bottles(n) + " of beer on the wall,")
    println(bottles(n) + " of beer!")
    println("Take one down, pass it around,")
    println(bottles(n - 1) + " of beer on the wall!")
  }
}
