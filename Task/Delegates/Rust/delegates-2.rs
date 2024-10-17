#![feature(specialization)]

trait Thingable {
    fn thing(&self) -> &str;
}

struct Delegator<T>(Option<T>);

struct Delegate {}

impl Thingable for Delegate {
    fn thing(&self) -> &'static str {
        "Delegate implementation"
    }
}

impl<T> Thingable for Delegator<T> {
    default fn thing(&self) -> &str {
        "Default implementation"
    }
}

impl<T: Thingable> Thingable for Delegator<T> {
    fn thing(&self) -> &str {
        self.0.as_ref().map(|d| d.thing()).unwrap_or("Default implmementation")
    }
}

fn main() {
    let d: Delegator<i32> = Delegator(None);
    println!("{}", d.thing());

    let d: Delegator<i32> = Delegator(Some(42));
    println!("{}", d.thing());

    let d: Delegator<Delegate> = Delegator(None);
    println!("{}", d.thing());

    let d: Delegator<Delegate> = Delegator(Some(Delegate {}));
    println!("{}", d.thing());
}
