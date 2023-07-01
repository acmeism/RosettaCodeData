####################################################################################################
# Base delegate.

type Delegate = ref object of RootObj
  nil

method thing(d: Delegate): string {.base.} =
  ## Default implementation of "thing".
  ## Using a method rather than a proc allows dynamic dispatch.
  "default implementation"


####################################################################################################
# Delegator.

type Delegator = object
  delegate: Delegate

proc initDelegator(d: Delegate = nil): Delegator =
  ## Create a delegator with given delegate or nil.
  if d.isNil:
    Delegator(delegate: Delegate())     # Will use a default delegate instance.
  else:
    Delegator(delegate: d)              # Use the provided delegate instance.

proc operation(d: Delegator): string =
  ## Calls the delegate.
  d.delegate.thing()


####################################################################################################
# Usage.

let d = initDelegator()
echo "Without any delegate: ", d.operation()

type Delegate1 = ref object of Delegate

let d1 = initDelegator(Delegate1())
echo "With a delegate which desn’t provide the “thing” method: ", d1.operation()

type Delegate2 = ref object of Delegate

method thing(d: Delegate2): string =
  "delegate implementation"

let d2 = initDelegator(Delegate2())
echo "With a delegate which provided the “thing” method: ", d2.operation()
