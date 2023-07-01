import "web" for Routes, App

Routes.GET("/") {
    return "Goodbye, World!"
}

App.run(8080)
