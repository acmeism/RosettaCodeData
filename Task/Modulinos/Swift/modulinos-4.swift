import Foundation
import ScriptedMain

public class Test {
  public class func main() {
    var meaning = ScriptedMain().meaningOfLife

    println("Test: The meaning of life is \(meaning)")
  }
}

#if TEST
@objc class TestAutoload {
  @objc class func load() {
    Test.main()
  }
}
#endif
