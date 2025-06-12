use std::cmp::Ordering;
use std::collections::BinaryHeap;

// We define a custom Pile struct instead of using Stack
#[derive(Clone, Eq, PartialEq)]
struct Pile<T: Ord> {
    values: Vec<T>,
}

impl<T: Ord> Pile<T> {
    fn new(value: T) -> Self {
        let mut values = Vec::new();
        values.push(value);
        Pile { values }
    }

    fn push(&mut self, value: T) {
        self.values.push(value);
    }

    fn pop(&mut self) -> Option<T> {
        self.values.pop()
    }

    fn top(&self) -> Option<&T> {
        self.values.last()
    }

    fn is_empty(&self) -> bool {
        self.values.is_empty()
    }
}

// For binary heap ordering (min-heap)
impl<T: Ord> Ord for Pile<T> {
    fn cmp(&self, other: &Self) -> Ordering {
        // Reverse the ordering for min-heap
        other.top().cmp(&self.top())
    }
}

impl<T: Ord> PartialOrd for Pile<T> {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn patience_sort<T: Ord + Clone>(slice: &mut [T]) {
    let mut piles: Vec<Pile<T>> = Vec::new();

    // Sort into piles
    for item in slice.iter().cloned() {
        // Find the pile to insert into
        let idx = match piles.binary_search_by(|pile| {
            if let Some(top) = pile.top() {
                top.cmp(&item)
            } else {
                Ordering::Greater // Should not happen
            }
        }) {
            Ok(idx) => idx,      // Found a pile with the same top value
            Err(idx) => idx,     // Position where we should insert new pile
        };

        if idx < piles.len() {
            piles[idx].push(item);
        } else {
            piles.push(Pile::new(item));
        }
    }

    // Convert to BinaryHeap for efficient merging
    let mut heap = BinaryHeap::from(piles);

    // Merge piles
    for item_slot in slice.iter_mut() {
        if let Some(mut smallest_pile) = heap.pop() {
            if let Some(top) = smallest_pile.pop() {
                *item_slot = top;

                if !smallest_pile.is_empty() {
                    heap.push(smallest_pile);
                }
            }
        }
    }

    assert!(heap.is_empty());
}

fn main() {
    let mut a = [4, 65, 2, -31, 0, 99, 83, 782, 1];
    patience_sort(&mut a);
    println!("{:?}", a);
}
