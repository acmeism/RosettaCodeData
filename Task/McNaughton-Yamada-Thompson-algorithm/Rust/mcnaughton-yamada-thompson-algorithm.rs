use std::cell::RefCell;
use std::collections::{HashMap, HashSet};
use std::hash::{Hash, Hasher};
use std::rc::Rc;

// Define the State structure
#[derive(Debug)]
struct State {
    label: Option<char>, // None represents epsilon transitions
    edge1: Option<Rc<RefCell<State>>>,
    edge2: Option<Rc<RefCell<State>>>,
}

impl State {
    fn new(label: Option<char>) -> Self {
        State {
            label,
            edge1: None,
            edge2: None,
        }
    }
}

// Wrapper struct for Rc<RefCell<State>>
#[derive(Debug, Clone)]
struct RcState(Rc<RefCell<State>>);

impl PartialEq for RcState {
    fn eq(&self, other: &Self) -> bool {
        Rc::ptr_eq(&self.0, &other.0)
    }
}

impl Eq for RcState {}

impl Hash for RcState {
    fn hash<H: Hasher>(&self, state: &mut H) {
        // Hash the pointer address
        let ptr = Rc::as_ptr(&self.0);
        ptr.hash(state);
    }
}

// Define the NFA structure
#[derive(Debug)]
struct NFA {
    initial: Option<Rc<RefCell<State>>>,
    accept: Option<Rc<RefCell<State>>>,
}

impl NFA {
    fn new(initial: Option<Rc<RefCell<State>>>, accept: Option<Rc<RefCell<State>>>) -> Self {
        NFA { initial, accept }
    }
}

// Function to convert infix regex to postfix using the Shunting Yard algorithm
fn shunt(infix: &str) -> String {
    let mut specials = HashMap::new();
    specials.insert('*', 60);
    specials.insert('+', 55);
    specials.insert('?', 50);
    specials.insert('.', 40);
    specials.insert('|', 20);

    let mut postfix = String::new();
    let mut stack: Vec<char> = Vec::new();

    for c in infix.chars() {
        if c == '(' {
            stack.push(c);
        } else if c == ')' {
            while let Some(&top) = stack.last() {
                if top == '(' {
                    break;
                } else {
                    postfix.push(stack.pop().unwrap());
                }
            }
            if let Some('(') = stack.last() {
                stack.pop();
            }
        } else if specials.contains_key(&c) {
            while let Some(&top) = stack.last() {
                if let Some(&top_prec) = specials.get(&top) {
                    if specials[&c] <= top_prec {
                        postfix.push(stack.pop().unwrap());
                        continue;
                    }
                }
                break;
            }
            stack.push(c);
        } else {
            postfix.push(c);
        }
    }

    while let Some(top) = stack.pop() {
        postfix.push(top);
    }

    postfix
}

// Function to compute the epsilon closure of a state
fn followes(state: Option<Rc<RefCell<State>>>) -> HashSet<RcState> {
    let mut states = HashSet::new();
    let mut stack = Vec::new();

    if let Some(state_rc) = state {
        stack.push(RcState(state_rc));
    }

    while let Some(s_rcstate) = stack.pop() {
        if !states.contains(&s_rcstate) {
            states.insert(s_rcstate.clone());
            let s = s_rcstate.0.borrow();
            if s.label.is_none() {
                if let Some(ref edge1) = s.edge1 {
                    stack.push(RcState(edge1.clone()));
                }
                if let Some(ref edge2) = s.edge2 {
                    stack.push(RcState(edge2.clone()));
                }
            }
        }
    }

    states
}

// Function to compile postfix regex into an NFA
fn compile_regex(postfix: &str) -> NFA {
    let mut nfa_stack: Vec<NFA> = Vec::new();

    for c in postfix.chars() {
        if c == '*' {
            let nfa1 = nfa_stack.pop().unwrap();
            let initial = Rc::new(RefCell::new(State::new(None)));
            let accept = Rc::new(RefCell::new(State::new(None)));
            initial.borrow_mut().edge1 = nfa1.initial.clone();
            initial.borrow_mut().edge2 = Some(accept.clone());
            if let Some(ref accept_state) = nfa1.accept {
                accept_state.borrow_mut().edge1 = nfa1.initial.clone();
                accept_state.borrow_mut().edge2 = Some(accept.clone());
            }
            nfa_stack.push(NFA::new(Some(initial), Some(accept)));
        } else if c == '.' {
            let nfa2 = nfa_stack.pop().unwrap();
            let nfa1 = nfa_stack.pop().unwrap();
            if let Some(ref accept_state) = nfa1.accept {
                accept_state.borrow_mut().edge1 = nfa2.initial.clone();
            }
            nfa_stack.push(NFA::new(nfa1.initial.clone(), nfa2.accept.clone()));
        } else if c == '|' {
            let nfa2 = nfa_stack.pop().unwrap();
            let nfa1 = nfa_stack.pop().unwrap();
            let initial = Rc::new(RefCell::new(State::new(None)));
            let accept = Rc::new(RefCell::new(State::new(None)));
            initial.borrow_mut().edge1 = nfa1.initial.clone();
            initial.borrow_mut().edge2 = nfa2.initial.clone();
            if let Some(ref accept_state1) = nfa1.accept {
                accept_state1.borrow_mut().edge1 = Some(accept.clone());
            }
            if let Some(ref accept_state2) = nfa2.accept {
                accept_state2.borrow_mut().edge1 = Some(accept.clone());
            }
            nfa_stack.push(NFA::new(Some(initial), Some(accept)));
        } else if c == '+' {
            let nfa1 = nfa_stack.pop().unwrap();
            let initial = Rc::new(RefCell::new(State::new(None)));
            let accept = Rc::new(RefCell::new(State::new(None)));
            initial.borrow_mut().edge1 = nfa1.initial.clone();
            if let Some(ref accept_state) = nfa1.accept {
                accept_state.borrow_mut().edge1 = nfa1.initial.clone();
                accept_state.borrow_mut().edge2 = Some(accept.clone());
            }
            nfa_stack.push(NFA::new(Some(initial), Some(accept)));
        } else if c == '?' {
            let nfa1 = nfa_stack.pop().unwrap();
            let initial = Rc::new(RefCell::new(State::new(None)));
            let accept = Rc::new(RefCell::new(State::new(None)));
            initial.borrow_mut().edge1 = nfa1.initial.clone();
            initial.borrow_mut().edge2 = Some(accept.clone());
            if let Some(ref accept_state) = nfa1.accept {
                accept_state.borrow_mut().edge1 = Some(accept.clone());
            }
            nfa_stack.push(NFA::new(Some(initial), Some(accept)));
        } else {
            let initial = Rc::new(RefCell::new(State::new(Some(c))));
            let accept = Rc::new(RefCell::new(State::new(None)));
            initial.borrow_mut().edge1 = Some(accept.clone());
            nfa_stack.push(NFA::new(Some(initial), Some(accept)));
        }
    }

    nfa_stack.pop().unwrap()
}

// Function to match a string against the regex
fn match_regex(infix: &str, s: &str) -> bool {
    let postfix = shunt(infix);
    let nfa = compile_regex(&postfix);

    let mut current = followes(nfa.initial.clone());
    let mut next_states = HashSet::new();

    for c in s.chars() {
        for state_rcstate in &current {
            let state = state_rcstate.0.borrow();
            if state.label == Some(c) {
                let follow = followes(state.edge1.clone());
                next_states.extend(follow);
            }
        }
        current = next_states;
        next_states = HashSet::new();
    }

    if let Some(accept_state) = nfa.accept {
        current.contains(&RcState(accept_state))
    } else {
        false
    }
}

fn main() {
    let infixes = vec!["a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c"];
    let strings = vec!["", "abc", "abbc", "abcc", "abad", "abbbc"];

    for infix in &infixes {
        for s in &strings {
            let result = match_regex(infix, s);
            println!("{} {} {}", if result { "True" } else { "False" }, infix, s);
        }
        println!("");
    }
}
