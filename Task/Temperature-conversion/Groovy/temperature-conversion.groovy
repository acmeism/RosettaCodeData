class Convert{
static void main(String[] args){
def c=21.0;
println("K "+c)
println("C "+k_to_c(c));
println("F "+k_to_f(k_to_c(c)));
println("R "+k_to_r(c));
}
static def k_to_c(def k=21.0){return k-273.15;}
static def k_to_f(def k=21.0){return ((k*9)/5)+32;}
static def k_to_r(def k=21.0){return k*1.8;}
}
