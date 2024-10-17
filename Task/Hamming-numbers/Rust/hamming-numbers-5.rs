extern crate num;
use num::bigint::BigUint;

use std::rc::Rc;
use std::cell::{UnsafeCell, RefCell};
use std::mem;

use std::time::Instant;

// implementation of Thunk closure here...

pub struct Thunk<'a, R>(Box<dyn FnOnce() -> R + 'a>);

impl<'a, R: 'a> Thunk<'a, R> {
    #[inline(always)]
    fn new<F: 'a + FnOnce() -> R>(func: F) -> Thunk<'a, R> {
        Thunk(Box::new(func))
    }
    #[inline(always)]
    fn invoke(self) -> R { self.0() }
}

// actual Lazy implementation starts here...

use self::LazyState::*;

pub struct Lazy<'a, T: 'a>(UnsafeCell<LazyState<'a, T>>);

enum LazyState<'a, T: 'a> {
    Unevaluated(Thunk<'a, T>),
    EvaluationInProgress,
    Evaluated(T)
}

impl<'a, T: 'a> Lazy<'a, T>{
    #[inline]
    pub fn new<'b, F>(thunk: F) -> Lazy<'b, T>
            where F: 'b + FnOnce() -> T {
        Lazy(UnsafeCell::new(Unevaluated(Thunk::new(thunk))))
    }
    #[inline]
    pub fn evaluated(val: T) -> Lazy<'a, T> {
        Lazy(UnsafeCell::new(Evaluated(val)))
    }
    #[inline]
    fn force<'b>(&'b self) { // not thread-safe
        unsafe {
            match *self.0.get() {
                Evaluated(_) => return, // nothing required; already Evaluated
                EvaluationInProgress =>
                    panic!("Lazy::force called recursively!!!"),
                _ => () // need to do following something else if Unevaluated...
            } // following eliminates recursive race; drops neither on replace:
            match mem::replace(&mut *self.0.get(), EvaluationInProgress) {
                Unevaluated(thnk) => { // Thunk can't call force on same Lazy
                    *self.0.get() = Evaluated(thnk.invoke());
                },
                _ => unreachable!() // already took care of other cases above.
            }
        }
    }
    #[inline]
    pub fn value<'b>(&'b self) -> &'b T {
        self.force(); // evaluatate if not evealutated
        match unsafe { &*self.0.get() } {
            &Evaluated(ref v) => v, // return value
            _ => { unreachable!() } // previous force guarantees Evaluated
        }
    }
    #[inline] // consumes the object to produce the value
    pub fn unwrap<'b>(self) -> T where T: 'b {
        self.force(); // evaluatate if not evealutated
        match { self.0.into_inner() } {
            Evaluated(v) => v,
            _ => unreachable!() // previous code guarantees Evaluated
        }
    }
}

// now for immutable persistent shareable (memoized) LazyList via Lazy above...

type RcLazyListNode<'a, T> = Rc<Lazy<'a, LazyList<'a, T>>>;

use self::LazyList::*;

#[derive(Clone)]
enum LazyList<'a, T: 'a + Clone> {
    /// The Empty List
    Empty,
    /// A list with one member and possibly another list.
    Cons(T, RcLazyListNode<'a, T>)
}

impl<'a, T: 'a + Clone> LazyList<'a, T> {
    #[inline]
    pub fn cons<F>(v: T, cntf: F) -> LazyList<'a, T>
            where F: 'a + FnOnce() -> LazyList<'a, T> {
        Cons(v, Rc::new(Lazy::new(cntf)))
    }
    #[inline]
    pub fn head<'b>(&'b self) -> &'b T {
        if let Cons(ref hd, _) = *self { return hd }
        panic!("LazyList::head called on an Empty LazyList!!!")
    }
/* // not used
    #[inline]
    pub fn tail<'b>(&'b self) -> &'b Lazy<'a, LazyList<'a, T>> {
        if let Cons(_, ref rlln) = *self { return &*rlln }
        panic!("LazyList::tail called on an Empty LazyList!!!")
    }
*/
    #[inline]
    pub fn unwrap(self) -> (T, RcLazyListNode<'a, T>) { // consumes the object
        if let Cons(hd, rlln) = self { return (hd, rlln) }
        panic!("LazyList::unwrap called on an Empty LazyList!!!")
    }
}

impl<'a, T: 'a + Clone> Iterator for LazyList<'a, T> {
    type Item = T;
    #[inline]
    fn next(&mut self) -> Option<Self::Item> {
        if let Empty = *self { return None }
        let oldll = mem::replace(self, Empty);
        let (hd, rlln) = oldll.unwrap();
        let mut newll = rlln.value().clone();
        // self now contains tail, newll contains the Empty
        mem::swap(self, &mut newll);
        Some(hd)
    }
}

// implements worker wrapper recursion closures using shared RcMFn variable...

type RcMFn<'a, T> = Rc<UnsafeCell<Box<dyn FnMut(T) -> T + 'a>>>;

// #[derive(Clone)]
// struct RcMFn<'a, T: 'a>(Rc<UnsafeCell<Box<FnMut() -> T + 'a>>>);

trait RcMFnMethods<'a, T> {
    fn create<F: FnMut(T) -> T + 'a>(v: F) -> RcMFn<'a, T>;
    fn invoke(&self, v: T) -> T;
    fn set<F: FnMut(T) -> T + 'a>(&self, v: F);
}

impl<'a, T: 'a> RcMFnMethods<'a, T> for RcMFn<'a, T> {
    // creates new value wrapper...
    fn create<F: FnMut(T) -> T + 'a>(v: F) -> RcMFn<'a, T> {
        Rc::new(UnsafeCell::new(Box::new(v)))
    }
    #[inline(always)] // needs to be faster to be worth it
    fn invoke(&self, v: T) -> T {
        unsafe { (*(*(*self).get()))(v) }
    }
    fn set<F: FnMut(T) -> T + 'a>(&self, v: F) {
        unsafe { *self.get() = Box::new(v); }
    }
}

type RcMVar<T> = Rc<RefCell<T>>;

trait RcMVarMethods<T> {
    fn create(v: T) -> Self;
    fn get(self: &Self) -> T;
    fn set(self: &Self, v: T);
}

impl<T: Clone> RcMVarMethods<T> for RcMVar<T> {
    fn create(v: T) -> RcMVar<T> { // creates new value wrapped in RcMVar
        Rc::new(RefCell::new(v))
    }
    #[inline]
    fn get(&self) -> T {
        self.borrow().clone()
    }
    fn set(&self, v: T) {
        *self.borrow_mut() = v;
    }
}

// finally what the task objective requires...

fn hammings() -> Box<dyn Iterator<Item = Rc<BigUint>>> {
    type LL<'a> = LazyList<'a, Rc<BigUint>>;
    fn merge<'a>(x: LL<'a>, y: LL<'a>) -> LL<'a> {
        let lte = { x.head() <= y.head() }; // private context for borrow
        if lte {
            let (hdx, tlx) = x.unwrap();
            LL::cons(hdx, move || merge(tlx.value().clone(), y))
        } else {
            let (hdy, tly) = y.unwrap();
            LL::cons(hdy, move || merge(x, tly.value().clone()))
        }
    }
    fn smult<'a>(m: BigUint, s: LL<'a>) -> LL<'a> { // like map m * but faster
        let smlt = RcMFn::create(move |ss: LL<'a>| ss);
        let csmlt = smlt.clone();
        smlt.set(move |ss: LL<'a>| {
            let (hd, tl) = ss.unwrap();
            let ccsmlt = csmlt.clone();
            LL::cons(Rc::new(&m * &*hd),
                             move || ccsmlt.invoke(tl.value().clone()))
        });
        smlt.invoke(s)
    }
    fn u<'a>(s: LL<'a>, n: usize) -> LL<'a> {
        let nb = BigUint::from(n);
        let rslt = RcMVar::create(Empty);
        let crslt = rslt.clone(); // same interior data...
        let cll = LL::cons(Rc::new(BigUint::from(1u8)),
                           move || crslt.get()); // gets future value
        // below sets future value for above closure...
        rslt.set(if let Empty =
            s { smult(nb, cll) } else { merge(s, smult(nb, cll)) });
        rslt.get()
    }
    fn rll<'a>() -> LL<'a> { [5, 3, 2].iter()
                                .fold(Empty, |ll, n| u(ll, *n) ) }
    let hmng = LL::cons(Rc::new(BigUint::from(1u8)), move || rll());
    Box::new(hmng.into_iter())
}

// and the required test outputs...

fn main() {
    print!("[");
    for (i, h) in hammings().take(20).enumerate() {
        if i != 0 { print!(",") }
        print!(" {}", h)
    }
    println!(" ]");

    println!("{}", hammings().take(1691).last().unwrap());

    let strt = Instant::now();

    let rslt = hammings().take(1000000).last().unwrap();

    let elpsd = strt.elapsed();
    let secs = elpsd.as_secs();
    let millis = (elpsd.subsec_nanos() / 1000000)as u64;
    let dur = secs * 1000 + millis;

    println!("{}", rslt);

    println!("This last took {} milliseconds.", dur);
}
