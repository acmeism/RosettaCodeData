import algorithm, random, sequtils, strformat, strutils, tables

type
  Revolver = array[6, bool]
  Action {.pure.} = enum Load, Spin, Fire, Error

const Actions = {'L': Load, 'S': Spin, 'F': Fire}.toTable

func spin(revolver: var Revolver; count: Positive) =
  revolver.rotateLeft(-count)

func load(revolver: var Revolver) =
  while revolver[1]:
    revolver.spin(1)
  revolver[1] = true
  revolver.spin(1)

func fire(revolver: var Revolver): bool =
  result = revolver[0]
  revolver.spin(1)

proc test(scenario: string) =
  let actions = scenario.mapIt(Actions.getOrDefault(it, Error))
  var deaths = 0
  var count = 100_000
  for _ in 1..count:
    var revolver: Revolver
    for action in actions:
      case action
      of Load:
        revolver.load()
      of Spin:
        revolver.spin(rand(1..6))
      of Fire:
        if revolver.fire():
          inc deaths
          break
      of Error:
        raise newException(ValueError, "encountered an unknown action.")
  echo &"""{100 * deaths / count:5.2f}% deaths for scenario {actions.join(", ")}."""

randomize()
for scenario in ["LSLSFSF", "LSLSFF", "LLSFSF", "LLSFF"]:
  test(scenario)
