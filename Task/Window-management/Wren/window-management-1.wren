/* Window_management.wren */

var GTK_WINDOW_TOPLEVEL = 0
var GTK_ORIENTATION_VERTICAL = 1
var GTK_BUTTONBOX_CENTER = 5

foreign class GtkWindow {
    construct new(type) {}

    foreign title=(title)
    foreign setDefaultSize(width, height)

    foreign add(widget)
    foreign connectDestroy()

    foreign showAll()
    foreign iconify()
    foreign deiconify()
    foreign maximize()
    foreign unmaximize()
    foreign move(x, y)
    foreign resize(width, height)
    foreign hide()
    foreign destroy()
}

foreign class GtkButtonBox {
    construct new(orientation) {}

    foreign spacing=(interval)
    foreign layout=(layoutStyle)

    foreign add(button)
}

foreign class GtkButton {
    construct newWithLabel(label) {}

    foreign connectClicked()
}

class Gdk {
    foreign static flush()
}

class C {
    foreign static sleep(secs)
}

var Window = GtkWindow.new(GTK_WINDOW_TOPLEVEL)
Window.title = "Window management"
Window.setDefaultSize(400, 400)
Window.connectDestroy()

class GtkCallbacks {
    static btnClicked(label) {
        if (label == "Minimize") {
            Window.iconify()
        } else if (label == "Unminimize") {
            Window.deiconify()
        } else if (label == "Maximize") {
            Window.maximize()
        } else if (label == "Unmaximize") {
            Window.unmaximize()
        } else if (label == "Move") {
            Window.move(0, 0) // move to top left hand corner of display
        } else if (label == "Resize") {
            Window.resize(600, 600)
        } else if (label == "Hide") {
            Window.hide()
            Gdk.flush()
            C.sleep(5) // wait 5 seconds
            Window.showAll()
        } else if (label == "Close") {
            Window.destroy()
        }
    }
}

var buttonBox = GtkButtonBox.new(GTK_ORIENTATION_VERTICAL)
buttonBox.spacing = 20
buttonBox.layout = GTK_BUTTONBOX_CENTER
Window.add(buttonBox)

var btnMin = GtkButton.newWithLabel("Minimize")
btnMin.connectClicked()
buttonBox.add(btnMin)

var btnUnmin = GtkButton.newWithLabel("Unminimize")
btnUnmin.connectClicked()
buttonBox.add(btnUnmin)

var btnMax = GtkButton.newWithLabel("Maximize")
btnMax.connectClicked()
buttonBox.add(btnMax)

var btnUnmax = GtkButton.newWithLabel("Unmaximize")
btnUnmax.connectClicked()
buttonBox.add(btnUnmax)

var btnMove = GtkButton.newWithLabel("Move")
btnMove.connectClicked()
buttonBox.add(btnMove)

var btnResize = GtkButton.newWithLabel("Resize")
btnResize.connectClicked()
buttonBox.add(btnResize)

var btnHide = GtkButton.newWithLabel("Hide")
btnHide.connectClicked()
buttonBox.add(btnHide)

var btnClose = GtkButton.newWithLabel("Close")
btnClose.connectClicked()
buttonBox.add(btnClose)

Window.showAll()
