use std::collections::BinaryHeap;
use std::cmp::Ordering;
use std::borrow::Cow;

#[derive(Eq, PartialEq)]
struct Item<'a> {
    priority: usize,
    task: Cow<'a, str>, // Takes either borrowed or owned string
}

impl<'a> Item<'a> {
    fn new<T>(p: usize, t: T) -> Self
        where T: Into<Cow<'a, str>>
    {
        Item {
            priority: p,
            task: t.into(),
        }
    }
}

// Manually implpement Ord so we have a min heap
impl<'a> Ord for Item<'a> {
    fn cmp(&self, other: &Self) -> Ordering {
        other.priority.cmp(&self.priority)
    }
}

// PartialOrd is required by Ord
impl<'a> PartialOrd for Item<'a> {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}


fn main() {
    let mut queue = BinaryHeap::with_capacity(5);
    queue.push(Item::new(3, "Clear drains"));
    queue.push(Item::new(4, "Feed cat"));
    queue.push(Item::new(5, "Make tea"));
    queue.push(Item::new(1, "Solve RC tasks"));
    queue.push(Item::new(2, "Tax return"));

    for item in queue {
        println!("{}", item.task);
    }
}
