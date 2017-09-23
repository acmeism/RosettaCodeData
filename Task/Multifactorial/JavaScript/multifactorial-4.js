function multifact(n, deg){
    return n <= deg ? n : n * multifact(n - deg, deg);
}
