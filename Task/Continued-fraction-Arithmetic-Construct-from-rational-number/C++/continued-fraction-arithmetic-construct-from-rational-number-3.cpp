int main() {
	int i = 0;
	for(SQRT2 n; i++ < 20; std::cout << n.nextTerm() << " ");
	std::cout << std::endl;
	for(r2cf n(14142,10000); n.moreTerms(); std::cout << n.nextTerm() << " ");
	std::cout << std::endl;
	for(r2cf n(14142136,10000000); n.moreTerms(); std::cout << n.nextTerm() << " ");
	std::cout << std::endl;
	return 0;
}
