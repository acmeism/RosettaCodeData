use std::cell::Cell;
use std::cell::RefCell;
use std::rc::Rc;
use std::rc::Weak;

fn a(k: i32, x1: &Fn() -> i32, x2: &Fn() -> i32, x3: &Fn() -> i32, x4: &Fn() -> i32, x5: &Fn() -> i32) -> i32 {
    let weak_holder: Rc<RefCell<Weak<Fn() -> i32>>> = Rc::new(RefCell::new(Weak::<fn() -> i32>::new()));
    let weak_holder2 = weak_holder.clone();
    let k_holder = Cell::new(k);
    let b: Rc<Fn() -> i32> = Rc::new(move || {
        let b = weak_holder2.borrow().upgrade().unwrap();
        k_holder.set(k_holder.get() - 1);
        return a(k_holder.get(), &*b, x1, x2, x3, x4);
    });
    weak_holder.replace(Rc::downgrade(&b));

    return if k <= 0 {x4() + x5()} else {b()}
}

pub fn main() {
    println!("{}", a(10, &||1, &||-1, &||-1, &||1, &||0));
}
