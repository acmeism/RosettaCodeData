use nix::unistd::{fork, ForkResult};
use std::process::id;

fn main() {
    match fork() {
        Ok(ForkResult::Parent { child, .. }) => {
            println!(
                "This is the original process(pid: {}). New child has pid: {}",
                id(),
                child
            );
        }
        Ok(ForkResult::Child) => println!("This is the new process(pid: {}).", id()),
        Err(_) => println!("Something went wrong."),
    }
}
