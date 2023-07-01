enum MyException : ErrorType {
  case U0
  case U1
}

func foo() throws {
  for i in 0 ... 1 {
    do {
      try bar(i)
    } catch MyException.U0 {
      print("Function foo caught exception U0")
    }
  }
}

func bar(i: Int) throws {
  try baz(i) // Nest those calls
}

func baz(i: Int) throws {
  if i == 0 {
    throw MyException.U0
  } else {
    throw MyException.U1
  }
}

try foo()
