struct MyStruct {}

impl MyStruct {
    fn static_method() {
        println "static method called";
    }

    fn method(self) {
        println "instance method called";
    }
}

fn main() {
    let mc = MyStruct{};
    mc.method();
    MyStruct::static_method();
}
