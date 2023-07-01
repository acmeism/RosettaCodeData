// version 1.2.21

import javafx.application.Application
import javafx.beans.property.SimpleLongProperty
import javafx.scene.Scene
import javafx.scene.control.Button
import javafx.scene.control.TextField
import javafx.scene.layout.HBox
import javafx.scene.layout.VBox
import javafx.stage.Stage
import javafx.util.converter.NumberStringConverter
import javafx.event.ActionEvent

val digits = Regex("[0-9]*")

class InteractFX : Application() {

    override fun start(stage: Stage) {
        val input = object : TextField("0") {
            // only accept numbers as input
            override fun replaceText(start: Int, end: Int, text: String) {
                if (text.matches(digits)) super.replaceText(start, end, text)
            }

            // only accept numbers on copy + paste
            override fun replaceSelection(text: String) {
                if (text.matches(digits)) super.replaceSelection(text)
            }
        }

        // when the textfield is empty, replace text with "0"
        input.textProperty().addListener { _, _, newValue ->
            if (newValue == null || newValue.trim().isEmpty()) input.text = "0"
        }

        // get a bi-directional bound long-property of the input value
        val inputValue = SimpleLongProperty()
        input.textProperty().bindBidirectional(inputValue, NumberStringConverter())

        // textfield is disabled when the current value is other than "0"
        input.disableProperty().bind(inputValue.isNotEqualTo(0))

        val increment = Button("Increment")
        increment.addEventHandler(ActionEvent.ACTION) { inputValue.set(inputValue.get() + 1) }

        // increment button is disabled when input is >= 10
        increment.disableProperty().bind(inputValue.greaterThanOrEqualTo(10))

        val decrement = Button("Decrement")
        decrement.addEventHandler(ActionEvent.ACTION) { inputValue.set(inputValue.get() - 1) }

        // decrement button is disabled when input is <= 0
        decrement.disableProperty().bind(inputValue.lessThanOrEqualTo(0))

        // layout
        val root = VBox()
        root.children.add(input)
        val buttons = HBox()
        buttons.children.addAll(increment, decrement)
        root.children.add(buttons)

        stage.scene = Scene(root)
        stage.sizeToScene()
        stage.show()
    }
}

fun main(args: Array<String>) {
    Application.launch(InteractFX::class.java, *args)
}
