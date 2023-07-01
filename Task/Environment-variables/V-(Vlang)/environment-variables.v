// Environment variables in V
// v run environment_variables.v
module main

import os

pub fn main() {
    print('In the $os.environ().len environment variables, ')
    println('\$HOME is set to ${os.getenv('HOME')}')
}
