import os

fn main() {
    println(is_empty_dir('../Check'))
}

fn is_empty_dir(name string) string {
    if os.is_dir(name) == false {return 'Directory name not exist!'}
    if os.is_dir(name) && os.is_dir_empty(name) == true {return 'Directory exists and is empty!'}
    return 'Directory not empty!'
}
