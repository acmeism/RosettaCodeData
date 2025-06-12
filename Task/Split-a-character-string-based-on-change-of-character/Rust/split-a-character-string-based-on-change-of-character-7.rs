#![feature(iter_intersperse)]
use itertools::Itertools;

Iterator::intersperse(r#"gHHH5YY++///\"#.split_duplicates(), ", ");
Itertools::intersperse(r#"gHHH5YY++///\"#.split_duplicates(), ", ");
