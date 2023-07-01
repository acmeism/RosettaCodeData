rune --src.e-awt 'def f := &lt;swing:makeJFrame>("Hello"); f.show(); f.addWindowListener(def _{to windowClosing(_) {interp.continueAtTop()} match _{}}); interp.blockAtTop()'
