use std::fmt;

struct Link {
    value: i32,
    next: Option<Box<Link>>,
}

impl Link {
    fn new(value: i32, next: Option<Box<Link>>) -> Self {
        Link { value, next }
    }
}

impl fmt::Display for Link {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "[{}", self.value)?;

        let mut current = &self.next;
        while let Some(link) = current {
            write!(f, " {}", link.value)?;
            current = &link.next;
        }

        write!(f, "]")
    }
}

fn link_ints(s: &[i32]) -> Option<Box<Link>> {
    if s.is_empty() {
        None
    } else {
        Some(Box::new(Link::new(s[0], link_ints(&s[1..]))))
    }
}

fn strand_sort(mut a: Option<Box<Link>>) -> Option<Box<Link>> {
    let mut result: Option<Box<Link>> = None;

    while let Some(mut head) = a {
        // Take the first element for our sublist
        a = head.next.take();

        // Build sublist
        let mut sublist = Some(head);
        let mut sublist_tail = sublist.as_mut().unwrap();

        // Process the remaining elements in the original list
        let mut current = a;
        a = None;

        // Start building a new 'a' list
        let mut new_a = None;
        let mut new_a_tail_ptr: *mut Option<Box<Link>> = &mut new_a;

        while let Some(mut node) = current {
            current = node.next.take();

            if node.value > sublist_tail.value {
                // Append to sublist
                sublist_tail.next = Some(node);
                sublist_tail = sublist_tail.next.as_mut().unwrap();
            } else {
                // Add to the new 'a' list
                unsafe {
                    *new_a_tail_ptr = Some(node);
                    new_a_tail_ptr = &mut (*new_a_tail_ptr).as_mut().unwrap().next;
                }
            }
        }

        a = new_a;

        // If result is empty, set it to the sublist
        if result.is_none() {
            result = sublist;
            continue;
        }

        // Merge sublist with result
        result = merge(result, sublist);
    }

    result
}

fn merge(list1: Option<Box<Link>>, list2: Option<Box<Link>>) -> Option<Box<Link>> {
    match (list1, list2) {
        (None, list2) => list2,
        (list1, None) => list1,
        (Some(mut head1), Some(mut head2)) => {
            // Start with the smaller value
            let mut result;
            let mut current;

            if head1.value <= head2.value {
                result = Some(head1);
                current = result.as_mut().unwrap();
                match current.next.take() {
                    Some(next) => head1 = next,
                    None => {
                        current.next = Some(head2);
                        return result;
                    }
                }
            } else {
                result = Some(head2);
                current = result.as_mut().unwrap();
                match current.next.take() {
                    Some(next) => head2 = next,
                    None => {
                        current.next = Some(head1);
                        return result;
                    }
                }
            }

            // Merge the rest
            loop {
                if head1.value <= head2.value {
                    current.next = Some(head1);
                    current = current.next.as_mut().unwrap();
                    match current.next.take() {
                        Some(next) => head1 = next,
                        None => {
                            current.next = Some(head2);
                            break;
                        }
                    }
                } else {
                    current.next = Some(head2);
                    current = current.next.as_mut().unwrap();
                    match current.next.take() {
                        Some(next) => head2 = next,
                        None => {
                            current.next = Some(head1);
                            break;
                        }
                    }
                }
            }

            result
        }
    }
}

fn main() {
    let a = link_ints(&[170, 45, 75, -90, -802, 24, 2, 66]);
    println!("before: {}", a.as_ref().map_or("None".to_string(), |link| link.to_string()));

    let b = strand_sort(a);
    println!("after:  {}", b.as_ref().map_or("None".to_string(), |link| link.to_string()));
}
