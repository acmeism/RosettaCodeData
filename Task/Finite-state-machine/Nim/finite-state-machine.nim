import strutils

type State {.pure.} = enum Ready, Waiting, Exit, Dispense, Refunding


proc getAnswer(message: string; answers: set[char]): char =
  while true:
    stdout.write message, ' '
    stdout.flushFile
    result = (stdin.readLine().toLowerAscii & ' ')[0]
    if result in answers: return


proc fsm =

  echo "Please enter your option when prompted"
  echo "(any characters after the first will be ignored)"
  var state = State.Ready

  while true:
    case state

    of State.Ready:
      let trans = getAnswer("\n(D)ispense or (Q)uit :", {'d', 'q'})
      state = if trans == 'd': State.Waiting else: State.Exit

    of State.Waiting:
      echo "OK, put your money in the slot"
      let trans = getAnswer("(S)elect product or choose a (R)efund :", {'s', 'r'})
      state = if trans == 's': State.Dispense else: State.Refunding

    of State.Dispense:
      discard getAnswer("(R)emove product :", {'r'})
      state = State.Ready

    of State.Refunding:
      # No transitions defined.
      echo "OK, refunding your money"
      state = State.Ready

    of State.Exit:
      echo "OK, quitting"
      break

fsm()
