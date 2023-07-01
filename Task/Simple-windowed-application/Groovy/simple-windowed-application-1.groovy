import groovy.swing.SwingBuilder

count = 0
new SwingBuilder().edt {
  frame(title:'Click frame', pack: true, show: true) {
    vbox {
      countLabel = label("There have been no clicks yet.")
      button('Click Me', actionPerformed: {count++; countLabel.text = "Clicked ${count} time(s)."})
    }
  }
}
