class SingletonClass {

static let sharedInstance = SingletonClass()

    ///Override the init method and make it private
    private override init(){
    // User can do additional manipulations here.
    }
}
// Usage
let sharedObject = SingletonClass.sharedInstance
