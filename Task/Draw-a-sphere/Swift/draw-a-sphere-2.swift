struct ContentView: View {

    var body: some View {

      let gradient = RadialGradient(gradient: Gradient(colors:[.white, .black]),
      center: .init(x: 0.4, y: 0.4), startRadius: 10, endRadius: 100)

      return Circle()
          .fill(gradient)
          .frame(width: 200, height: 200)

    }
}
