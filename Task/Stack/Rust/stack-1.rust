fn main() {
    let mut stack = Vec::new();
    stack.push("Element1");
    stack.push("Element2");
    stack.push("Element3");

    assert_eq!(Some(&"Element3"), stack.last());
    assert_eq!(Some("Element3"), stack.pop());
    assert_eq!(Some("Element2"), stack.pop());
    assert_eq!(Some("Element1"), stack.pop());
    assert_eq!(None, stack.pop());
}
