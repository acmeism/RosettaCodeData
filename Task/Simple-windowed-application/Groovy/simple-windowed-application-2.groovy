import groovy.swing.SwingBuilder
import groovy.beans.Bindable

@Bindable class Model {
   Integer count = 0
}
model = new Model()
new SwingBuilder().edt {
  frame(title:'Click frame', pack: true, show: true) {
    vbox {
      label(text: bind(source: model, sourceProperty: 'count',
        converter: { v -> !v ? "There have been no clicks yet." : "Clicked ${v} time(s)."}))
      button('Click Me', actionPerformed: {model.count++})
    }
  }
}
