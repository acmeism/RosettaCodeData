class Delegator
  operation: ->
    if @delegate and typeof (@delegate.thing) is "function"
      return @delegate.thing()
    "default implementation"

class Delegate
  thing: ->
    "Delegate Implementation"

testDelegator = ->
  # Delegator with no delegate.
  a = new Delegator()
  console.log a.operation()

  # Delegator with delegate not implementing "thing"
  a.delegate = "A delegate may be any object"
  console.log a.operation()

  # Delegator with delegate that does implement "thing"
  a.delegate = new Delegate()
  console.log a.operation()

testDelegator()
