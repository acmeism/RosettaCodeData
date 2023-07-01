#![feature(conservative_impl_trait)]
fn compose<'a,F,G,T,U,V>(f: F, g: G) -> impl Fn(T) -> V + 'a
    where F: Fn(U) -> V + 'a,
          G: Fn(T) -> U + 'a,
{
   move |x| f(g(x))
}
