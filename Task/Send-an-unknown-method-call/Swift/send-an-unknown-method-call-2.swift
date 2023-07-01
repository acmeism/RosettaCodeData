@dynamicCallable
protocol FunDynamics {
  var parent: MyDynamicThing { get }

  func dynamicallyCall(withArguments args: [Int]) -> MyDynamicThing
  func dynamicallyCall(withKeywordArguments args: [String: Int]) -> MyDynamicThing
}

extension FunDynamics {
  func dynamicallyCall(withKeywordArguments args: [String: Int]) -> MyDynamicThing {
    if let add = args["adding"] {
      parent.n += add
    }

    if let sub = args["subtracting"] {
      parent.n -= sub
    }

    return parent
  }
}

@dynamicMemberLookup
class MyDynamicThing {
  var n: Int

  init(n: Int) {
    self.n = n
  }

  subscript(dynamicMember member: String) -> FunDynamics {
    switch member {
    case "subtract":
      return Subtracter(parent: self)
    case "add":
      return Adder(parent: self)
    case _:
      return Nuller(parent: self)
    }
  }
}

struct Nuller: FunDynamics {
  var parent: MyDynamicThing

  func dynamicallyCall(withArguments args: [Int]) -> MyDynamicThing { parent }
}

struct Subtracter: FunDynamics {
  var parent: MyDynamicThing

  func dynamicallyCall(withArguments args: [Int]) -> MyDynamicThing {
    switch args.count {
    case 1:
      parent.n -= args[0]
    case _:
      print("Unknown call")
    }

    return parent
  }
}

struct Adder: FunDynamics {
  var parent: MyDynamicThing

  func dynamicallyCall(withArguments arg: [Int]) -> MyDynamicThing {
   switch arg.count {
   case 1:
     parent.n += arg[0]
   case _:
     print("Unknown call")
   }

    return parent
  }
}

let thing =
  MyDynamicThing(n: 0)
    .add(20)
    .divide(2) // Unhandled call, do nothing
    .subtract(adding: 10, subtracting: 14)

print(thing.n)
