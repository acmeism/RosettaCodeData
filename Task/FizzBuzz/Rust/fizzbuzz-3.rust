 #![no_std]
#![feature(asm, lang_items, libc, no_std, start)]

extern crate libc;

const LEN: usize = 413;
static OUT: [u8; LEN] = *b"\
    1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz\n\
    16\n17\nFizz\n19\nBuzz\nFizz\n22\n23\nFizz\nBuzz\n26\nFizz\n28\n29\nFizzBuzz\n\
    31\n32\nFizz\n34\nBuzz\nFizz\n37\n38\nFizz\nBuzz\n41\nFizz\n43\n44\nFizzBuzz\n\
    46\n47\nFizz\n49\nBuzz\nFizz\n52\n53\nFizz\nBuzz\n56\nFizz\n58\n59\nFizzBuzz\n\
    61\n62\nFizz\n64\nBuzz\nFizz\n67\n68\nFizz\nBuzz\n71\nFizz\n73\n74\nFizzBuzz\n\
    76\n77\nFizz\n79\nBuzz\nFizz\n82\n83\nFizz\nBuzz\n86\nFizz\n88\n89\nFizzBuzz\n\
    91\n92\nFizz\n94\nBuzz\nFizz\n97\n98\nFizz\nBuzz\n";

#[start]
fn start(_argc: isize, _argv: *const *const u8) -> isize {
    unsafe {
        asm!(
            "
            mov $$1, %rax
            mov $$1, %rdi
            mov $0, %rsi
            mov $1, %rdx
            syscall
            "
            :
            : "r" (&OUT[0]) "r" (LEN)
            : "rax", "rdi", "rsi", "rdx"
            :
        );
    }
    0
}

#[lang = "eh_personality"] extern fn eh_personality() {}
#[lang = "panic_fmt"] extern fn panic_fmt() {}
