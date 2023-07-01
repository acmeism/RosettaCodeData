import Foundation

func stripBlocks(from str: String, open: String = "/*", close: String = "*/") -> String {
  guard !open.isEmpty && !close.isEmpty else {
    return str
  }

  var ret = str

  while let begin = ret.range(of: open), let end = ret[begin.upperBound...].range(of: close) {
    ret.replaceSubrange(Range(uncheckedBounds: (begin.lowerBound, end.upperBound)), with: "")
  }

  return ret
}

let test = """
             /**
           * Some comments
           * longer comments here that we can parse.
           *
           * Rahoo
           */
           function subroutine() {
            a = /* inline comment */ b + c ;
           }
           /*/ <-- tricky comments */

           /**
            * Another comment.
            */
            function something() {
            }
           """

print(stripBlocks(from: test))
