extern crate num;
use num::bigint::BigUint;

use core::cmp::Ordering;

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

#[derive(Clone)]
struct LogRep {lg: f64, x2: u32, x3: u32, x5: u32}

const ONE: LogRep = LogRep { lg: 0f64, x2: 0u32, x3: 0u32, x5: 0u32 };
const LB3: f64 = 1.5849625007211563f64; // log base two of 3f64
const LB5: f64 = 2.321928094887362f64; // log base two of 5f64

impl PartialEq for LogRep {
    #[inline]
    fn eq(&self, other: &Self) -> bool {
        self.lg == other.lg
    }
}

impl Eq for LogRep {}

impl PartialOrd for LogRep {
    #[inline]
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        self.lg.partial_cmp(&other.lg)
    }
}

trait LogRepMults {
    fn mult2(lr: LogRep) -> LogRep;
    fn mult3(lr: LogRep) -> LogRep;
    fn mult5(lr: LogRep) -> LogRep;
}

impl LogRepMults for LogRep {
    #[inline]
    fn mult2(lr: LogRep) -> LogRep {
        LogRep { lg: lr.lg + 1f64, x2: lr.x2 + 1, x3: lr.x3, x5: lr.x5 }
    }
    #[inline]
    fn mult3(lr: LogRep) -> LogRep {
        LogRep { lg: lr.lg + LB3, x2: lr.x2, x3: lr.x3 + 1, x5: lr.x5 }
    }
    #[inline]
    fn mult5(lr: LogRep) -> LogRep {
        LogRep { lg: lr.lg + LB5, x2: lr.x2, x3: lr.x3, x5: lr.x5 + 1 }
    }
}

fn logrep2biguint(lr: LogRep) -> BigUint {
    let two = BigUint::from(2u8);
    let three = BigUint::from(3u8);
    let five = BigUint::from(5u8);
    fn xpnd(vm: u32, n: BigUint) -> BigUint {
        let mut rslt = BigUint::from(1u8);
        let mut v = vm; let mut bsm = n;
        while v > 0u32 {
            if v & 1u32 != 0u32 { rslt = rslt * &bsm }
            bsm = &bsm.clone() * bsm; v = v >> 1;
        }
        rslt
    }
    xpnd(lr.x2, two) * xpnd(lr.x3, three) * xpnd(lr.x5, five)
}

fn hammings() -> Box<dyn Iterator<Item = LogRep>> {
    type LR = LogRep;
    type LL<'a> = LazyList<'a, LR>;
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
    fn smult<'a>(m: fn(LogRep) -> LogRep, s: LL<'a>) -> LL<'a> { // like map m * but faster
        let smlt = RcMFn::create(move |ss: LL<'a>| ss);
        let csmlt = smlt.clone();
        smlt.set(move |ss: LL<'a>| {
            let (hd, tl) = ss.unwrap();
            let ccsmlt = csmlt.clone();
            LL::cons(m(hd), move || ccsmlt.invoke(tl.value().clone()))
        });
        smlt.invoke(s)
    }
    fn u<'a>(s: LL<'a>, f: fn(LogRep) -> LogRep) -> LL<'a> {
        let rslt = RcMVar::create(Empty);
        let crslt = rslt.clone(); // same interior data...
        let cll = LL::cons(ONE, move || crslt.get()); // gets future value
        // below sets future value for above closure...
        rslt.set(if let Empty =
            s { smult(f, cll) } else { merge(s, smult(f, cll)) });
        rslt.get()
    }
    fn rll<'a>() -> LL<'a> { [LR::mult5, LR::mult3, LR::mult2].iter()
                                .fold(Empty, |ll, mf| u(ll, *mf) ) }
    let hmng = LL::cons(ONE, move || rll());
    Box::new(hmng.into_iter())
}

// and the required test outputs...

fn main() {
    print!("[");
    for (i, h) in hammings().take(20).enumerate() {
        if i != 0 { print!(",") }
        print!(" {}", logrep2biguint(h))
    }
    println!(" ]");

    println!("{}", logrep2biguint(hammings().take(1691).last().unwrap()));

    let strt = Instant::now();

    let rslt = hammings().take(1000000).last().unwrap();

    let elpsd = strt.elapsed();
    let secs = elpsd.as_secs();
    let millis = (elpsd.subsec_nanos() / 1000000)as u64;
    let dur = secs * 1000 + millis;

    println!("{}", logrep2biguint(rslt));

    println!("This last took {} milliseconds.", dur);
}
