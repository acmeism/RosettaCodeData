use std::error::Error;
use std::fs::File;
use std::io::{self,prelude::*};
use std::net::TcpStream;

// Declare an Identify trait and implement it for a bunch of types
pub trait Identify {
    fn id(&self) -> &'static str;
}

// Declare a macro to compact away the boilerplate
macro_rules! declare_id {
    ( $struct:ty, $id:ident ) => (
        impl Identify for $struct {
            fn id(&self) -> &'static str {
                return stringify!($id);
            }
        }
    )
}

// Use the macro to `impl` the Identify trait for a bunch of types
declare_id!(io::Empty, empty);
declare_id!(File, file_handle);
declare_id!(TcpStream, tcp_stream);
declare_id!(u8, int8);
declare_id!(&str, string);

// This uses monomorphic dispatch via generics.
// A copy of the function will be generated for each input type encountered
pub fn calc_size<R: Read + Identify>(readable: R) {
    let id = readable.id();
    let mut size = 0;

    for _byte in readable.bytes() {
        size += 1;
    }
    println!(" {}: {} bytes", id, size);
}

// This uses polymorphic dispatch via type erasure
pub fn identify(thing: &dyn Identify) {
    println!(" Got {}", thing.id());
}

fn main() -> Result<(), Box<dyn Error>> {
    println!("Monomorphic Generic Interface:");
    calc_size(File::open("/bin/sh")?);
    calc_size(io::empty());
    calc_size(TcpStream::connect("127.0.0.1:37")?);

    println!("\nPolymorphic Interface:");
    for x in &[&15u8 as &dyn Identify, &"Hello" as &dyn Identify] {
        identify(*x);
    }

    Ok(())
}
