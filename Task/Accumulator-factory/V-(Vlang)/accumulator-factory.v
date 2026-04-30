struct Generator {
	mut:
    a_n []f64
}

fn (mut gen Generator) generator(ir f64) fn (f64) f64 {
    gen.a_n << ir
    id := gen.a_n.len - 1
    return fn (mut gen Generator, id int) fn (f64) f64 {
        return fn [mut gen, id] (d f64) f64 {
            gen.a_n[id] += d
            return gen.a_n[id]
        }
    }(mut gen, id)
}

fn main() {
    mut o_generator := Generator{}
    accumulator := o_generator.generator(1)
    println(accumulator(5))
    o_generator.generator(3)
    println(accumulator(2.3))
}
