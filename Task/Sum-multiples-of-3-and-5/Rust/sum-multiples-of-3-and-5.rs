extern crate rug;

use rug::Integer;
use rug::ops::Pow;

fn main() {
    for i in [3, 20, 100, 1_000].iter() {
        let ten = Integer::from(10);
        let mut limit = Integer::from(Integer::from(&ten.pow(*i as u32)) - 1);
        let mut aux_3_1 = &limit.mod_u(3u32);
        let mut aux_3_2 = Integer::from(&limit - aux_3_1);
        let mut aux_3_3 = Integer::from(&aux_3_2/3);
        let mut aux_3_4 = Integer::from(3 + aux_3_2);
        let mut aux_3_5 = Integer::from(&aux_3_3*&aux_3_4);
        let mut aux_3_6 = Integer::from(&aux_3_5/2);

        let mut aux_5_1 = &limit.mod_u(5u32);
        let mut aux_5_2 = Integer::from(&limit - aux_5_1);
        let mut aux_5_3 = Integer::from(&aux_5_2/5);
        let mut aux_5_4 = Integer::from(5 + aux_5_2);
        let mut aux_5_5 = Integer::from(&aux_5_3*&aux_5_4);
        let mut aux_5_6 = Integer::from(&aux_5_5/2);

        let mut aux_15_1 = &limit.mod_u(15u32);
        let mut aux_15_2 = Integer::from(&limit - aux_15_1);
        let mut aux_15_3 = Integer::from(&aux_15_2/15);
        let mut aux_15_4 = Integer::from(15 + aux_15_2);
        let mut aux_15_5 = Integer::from(&aux_15_3*&aux_15_4);
        let mut aux_15_6 = Integer::from(&aux_15_5/2);

        let mut result_aux_1 = Integer::from(&aux_3_6 + &aux_5_6);
        let mut result = Integer::from(&result_aux_1 - &aux_15_6);

        println!("Sum for 10^{} : {}",i,result);
    }
}
