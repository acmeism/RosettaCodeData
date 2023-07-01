let libs = [
  ("des_system_lib", ["std", "synopsys", "std_cell_lib", "des_system_lib", "dw02", "dw01", "ramlib", "ieee"]),
  ("dw01", ["ieee", "dw01", "dware", "gtech"]),
  ("dw02", ["ieee", "dw02", "dware"]),
  ("dw03", ["std", "synopsys", "dware", "dw03", "dw02", "dw01", "ieee", "gtech"]),
  ("dw04", ["dw04", "ieee", "dw01", "dware", "gtech"]),
  ("dw05", ["dw05", "ieee", "dware"]),
  ("dw06", ["dw06", "ieee", "dware"]),
  ("dw07", ["ieee", "dware"]),
  ("dware", ["ieee", "dware"]),
  ("gtech", ["ieee", "gtech"]),
  ("ramlib", ["std", "ieee"]),
  ("std_cell_lib", ["ieee", "std_cell_lib"]),
  ("synopsys", [])
]

struct Library {
  var name: String
  var children: [String]
  var numParents: Int
}

func buildLibraries(_ input: [(String, [String])]) -> [String: Library] {
  var libraries = [String: Library]()

  for (name, parents) in input {
    var numParents = 0

    for parent in parents where parent != name {
      numParents += 1

      libraries[parent, default: Library(name: parent, children: [], numParents: 0)].children.append(name)
    }

    libraries[name, default: Library(name: name, children: [], numParents: numParents)].numParents = numParents
  }

  return libraries
}

func topologicalSort(libs: [String: Library]) -> [String]? {
  var libs = libs
  var needsProcessing = Set(libs.keys)
  var options = libs.compactMap({ $0.value.numParents == 0 ? $0.key : nil })
  var sorted = [String]()

  while let cur = options.popLast() {
    for children in libs[cur]?.children ?? [] {
      libs[children]?.numParents -= 1

      if libs[children]?.numParents == 0 {
        options.append(libs[children]!.name)
      }
    }

    libs[cur]?.children.removeAll()

    sorted.append(cur)
    needsProcessing.remove(cur)
  }

  guard needsProcessing.isEmpty else {
    return nil
  }

  return sorted
}

print(topologicalSort(libs: buildLibraries(libs))!)
