use std::cell::RefCell;
use std::rc::{Rc, Weak};

pub struct Factory {
    count: RefCell<u32>,
}

pub struct Widget {
    parent: Weak<Factory>,
}

impl Factory {
    pub fn new() -> Rc<Self> {
        Rc::new(Factory {
            count: RefCell::new(0),
        })
    }

    pub fn get_widget(self: &Rc<Self>) -> Widget {
        Widget::new(Rc::downgrade(self))
    }

    fn increment_count(&self) {
        *self.count.borrow_mut() += 1;
        println!("Widget spawning. There are now {} Widgets instantiated.", self.count.borrow());
    }

    fn decrement_count(&self) {
        *self.count.borrow_mut() -= 1;
        println!("Widget dying. There are now {} Widgets instantiated.", self.count.borrow());
    }
}

impl Widget {
    fn new(parent: Weak<Factory>) -> Self {
        if let Some(factory) = parent.upgrade() {
            factory.increment_count();
        }

        Widget { parent }
    }
}

impl Drop for Widget {
    fn drop(&mut self) {
        if let Some(factory) = self.parent.upgrade() {
            factory.decrement_count();
        }
    }
}

fn main() {
    let factory = Factory::new();

    let widget1 = factory.get_widget();
    let widget2 = factory.get_widget();
    drop(widget1);

    let widget3 = factory.get_widget();
    drop(widget3);
    drop(widget2);
}
