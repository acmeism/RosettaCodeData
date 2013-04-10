def guiBullsAndCows() {
    var lastGuess := ""
    def op := <unsafe:javax.swing.makeJOptionPane>
    return bullsAndCows(fn {
      lastGuess := op.showInputDialog(null, "Enter your guess:", lastGuess)
      if (lastGuess == null) {
        # canceled, so just fail to return an answer and let the game logic get GCed
        Ref.promise()[0]
      } else {
        lastGuess
      }
    }, fn msg {
      op.showMessageDialog(null, msg)
    }, entropy)
}
