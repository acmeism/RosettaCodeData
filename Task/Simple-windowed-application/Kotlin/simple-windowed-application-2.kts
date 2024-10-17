import tornadofx.*

class ClicksView: View("Clicks example") {
    var clicks = 0
    override val root = vbox(5) {
        var label1 = label("There have been no clicks yet")
        button("Click me!") { action { label1.text = "Clicked ${++clicks} times." } }
    }
}

class ClicksApp: App(ClicksView::class)

fun main(args: Array<String>) = launch<ClicksApp>(args)
