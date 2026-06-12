use std::rc::Rc;
use std::collections::VecDeque;

#[derive(Clone)]
pub struct VList<T: Clone + Default + std::fmt::Debug> {
    datas: VecDeque<Rc<Vec<T>>>,
    offset: usize,
}

impl<T: Clone + Default + std::fmt::Debug> VList<T> {
    pub fn new() -> Self {
        VList {
            datas: VecDeque::new(),
            offset: 0,
        }
    }

    // modify structure instead of returning a new one like the pure functional way does
    pub fn cons(&mut self, a: T) {
        if self.datas.is_empty() {
            let base = Rc::new(vec![a]);
            self.datas.push_front(base);
            self.offset = 0;
            return;
        }

        if self.offset == 0 {
            let new_capacity = self.datas.front().unwrap().len() * 2;
            let new_offset = new_capacity - 1;
            let mut base = vec![T::default(); new_capacity];
            base[new_offset] = a;
            self.datas.push_front(Rc::new(base));
            self.offset = new_offset;
            return;
        }

        self.offset -= 1;
        // We need to create a new vector since Rc<Vec<T>> is immutable
        let mut new_vec = (**self.datas.front().unwrap()).clone();
        new_vec[self.offset] = a;
        self.datas.pop_front();
        self.datas.push_front(Rc::new(new_vec));
    }

    // lisp like cdr to keep previous version
    pub fn cdr(&self) -> VList<T> {
        if self.datas.is_empty() {
            // cdr of empty list is an empty list
            return self.clone();
        }

        let mut new_vlist = VList {
            datas: self.datas.clone(),
            offset: self.offset + 1,
        };

        if new_vlist.offset < new_vlist.datas.front().unwrap().len() {
            return new_vlist;
        }

        new_vlist.offset = 0;
        new_vlist.datas.pop_front();
        new_vlist
    }

    // compute the length of the list.  (It's O(1).)
    pub fn length(&self) -> usize {
        if self.datas.is_empty() {
            return 0;
        }
        self.datas.front().unwrap().len() * 2 - self.offset - 1
    }

    pub fn index(&self, i: usize) -> Option<&T> {
        if self.datas.is_empty() {
            return None;
        }

        let mut idx = i + self.offset;
        for data in &self.datas {
            if idx < data.len() {
                return Some(&data[idx]);
            }
            idx -= data.len();
        }
        None
    }

    pub fn print_list(&self) {
        if self.datas.is_empty() {
            println!("[]");
            return;
        }

        let first = self.datas.front().unwrap();
        print!("[");

        for i in self.offset..first.len() {
            print!(" {:?}", first[i]);
        }

        for data in self.datas.iter().skip(1) {
            for i in 0..data.len() {
                print!(" {:?}", data[i]);
            }
        }

        println!(" ]");
    }

    // One more method for demonstration purposes
    pub fn print_structure(&self) {
        println!("offset:{}", self.offset);
        if self.datas.is_empty() {
            println!("[]");
            return;
        }

        let first = self.datas.front().unwrap();
        print!("[");
        for i in self.offset..first.len() {
            print!(" {:?}", first[i]);
        }
        println!(" ]");

        for data in self.datas.iter().skip(1) {
            print!("[");
            for i in 0..data.len() {
                print!(" {:?}", data[i]);
            }
            println!(" ]");
        }
        println!();
    }
}

// For types that don't have a meaningful default value
impl<T: Clone + Default + std::fmt::Debug> Default for VList<T> {
    fn default() -> Self {
        Self::new()
    }
}

fn main() {
    let mut vlist = VList::<char>::new();

    println!("zero value for type.  empty vList:");
    vlist.print_list();
    vlist.print_structure();

    println!("demonstrate cons. 6 elements added:");
    for a in ('1'..='6').rev() {
        vlist.cons(a);
    }
    vlist.print_list();
    vlist.print_structure();

    println!("demonstrate cdr. 1 element removed:");
    vlist = vlist.cdr();
    vlist.print_list();
    vlist.print_structure();

    println!("demonstrate length. length = {}", vlist.length());

    if let Some(element) = vlist.index(3) {
        println!("demonstrate element access. v[3] = {:?}", element);
    }

    println!("show cdr releasing segment. 2 elements removed:");
    vlist = vlist.cdr().cdr();
    vlist.print_list();
    vlist.print_structure();
}
