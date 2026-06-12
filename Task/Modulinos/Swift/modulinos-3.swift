import Foundation

public class ScriptedMain {
  public var meaningOfLife = 42

  public init() {}

  public class func main() {
    var meaning = ScriptedMain().meaningOfLife

    println("Main: The meaning of life is \(meaning)")
  }
}

#if SCRIPTEDMAIN
@objc class ScriptedMainAutoload {
  @objc class func load() {
    ScriptedMain.main()
  }
}
#endif
