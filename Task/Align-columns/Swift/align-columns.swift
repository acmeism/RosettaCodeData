import Foundation

extension String {
  func dropLastIf(_ char: Character) -> String {
    if last == char {
      return String(dropLast())
    } else {
      return self
    }
  }
}

enum Align {
  case left, center, right
}

func getLines(input: String) -> [String] {
  input
    .components(separatedBy: "\n")
    .map({ $0.replacingOccurrences(of: " ", with: "").dropLastIf("$") })
}

func getColWidths(from: String) -> [Int] {
  var widths = [Int]()
  let lines = getLines(input: from)

  for line in lines {
    let lens = line.components(separatedBy: "$").map({ $0.count })

    for (i, len) in lens.enumerated() {
      if i < widths.count {
        widths[i] = max(widths[i], len)
      } else {
        widths.append(len)
      }
    }
  }

  return widths
}

func alignCols(input: String, align: Align = .left) -> String {
  let widths = getColWidths(from: input)
  let lines = getLines(input: input)
  var res = ""

  for line in lines {
    for (str, width) in zip(line.components(separatedBy: "$"), widths) {
      let blanks = width - str.count
      let pre: Int, post: Int

      switch align {
      case .left:
        (pre, post) = (0, blanks)
      case .center:
        (pre, post) = (blanks / 2, (blanks + 1) / 2)
      case .right:
        (pre, post) = (blanks, 0)
      }

      res += String(repeating: " ", count: pre)
      res += str
      res += String(repeating: " ", count: post)
      res += " "
    }

    res += "\n"
  }

  return res
}

let input = """
            Given$a$text$file$of$many$lines,$where$fields$within$a$line$
            are$delineated$by$a$single$'dollar'$character,$write$a$program
            that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
            column$are$separated$by$at$least$one$space.
            Further,$allow$for$each$word$in$a$column$to$be$either$left$
            justified,$right$justified,$or$center$justified$within$its$column.
            """

print(alignCols(input: input))
print()
print(alignCols(input: input, align: .center))
print()
print(alignCols(input: input, align: .right))
