#[derive(Copy, Clone, Debug)]
enum Endianness {
    Big, Little,
}

impl Endianness {
    fn target() -> Self {
        #[cfg(target_endian = "big")]
        {
            Endianness::Big
        }
        #[cfg(not(target_endian = "big"))]
        {
            Endianness::Little
        }
    }
}

fn main() {
    println!("Word size: {} bytes", std::mem::size_of::<usize>());
    println!("Endianness: {:?}", Endianness::target());
}
