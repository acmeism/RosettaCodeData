//! Documentation for the module
//!
//! **Lorem ipsum** dolor sit amet, consectetur adipiscing elit. Aenean a
//! sagittis sapien, eu pellentesque ex. Nulla facilisi. Praesent eget sapien
//! sollicitudin, laoreet ipsum at, fringilla augue. In hac habitasse platea
//! dictumst. Nunc in neque sed magna suscipit mattis sed quis mi. Curabitur
//! quis mi a ante mollis commodo. Sed tincidunt ut metus vel accumsan.
#![doc(html_favicon_url = "https://example.com/favicon.ico")]
#![doc(html_logo_url = "https://example.com/logo.png")]

/// Documentation for a constant
pub const THINGY: u32 = 42;

/// Documentation for a Rust `enum` (tagged union)
pub enum Whatsit {
    /// Documentation for the `Yo` variant
    Yo(Whatchamabob),
    /// Documentation for the `HoHo` variant
    HoHo,
}

/// Documentation for a data structure
pub struct Whatchamabob {
    /// Doodads do dad
    pub doodad: f64,
    /// Whether or not this is a thingamabob
    pub thingamabob: bool
}

/// Documentation for a trait (interface)
pub trait Frobnify {
    /// `Frobnify` something
    fn frob(&self);
}

/// Documentation specific to this struct's implementation of `Frobnify`
impl Frobnify for Whatchamabob {
    /// `Frobnify` the `Whatchamabob`
    fn frob(&self) {
        println!("Frobbed: {}", self.doodad);
    }
}

/// Documentation for a function
///
/// Pellentesque sodales lacus nisi, in malesuada lectus vestibulum eget.
/// Integer rhoncus imperdiet justo. Pellentesque egestas sem ac
/// consectetur suscipit. Maecenas tempus dignissim purus, eu tincidunt mi
/// tincidunt id. Morbi ac laoreet erat, eu ultricies neque. Fusce molestie
/// urna quis nisl condimentum, sit amet fringilla nunc ornare. Pellentesque
/// vestibulum ac nibh eu accumsan. In ornare orci at rhoncus finibus. Donec
/// sed ipsum ex. Pellentesque ante nisl, pharetra id purus auctor, euismod
/// semper erat. Nunc sit amet eros elit.
pub fn main() {
    let foo = Whatchamabob{ doodad: 1.2, thingamabob: false };
    foo.frob();
}
