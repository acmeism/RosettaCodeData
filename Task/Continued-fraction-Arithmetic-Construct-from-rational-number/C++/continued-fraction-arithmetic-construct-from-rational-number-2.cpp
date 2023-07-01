int main() {
	for(r2cf n(1,2); n.moreTerms(); std::cout << n.nextTerm() << " ");
	std::cout << std::endl;
	for(r2cf n(3,1); n.moreTerms(); std::cout << n.nextTerm() << " ");
	std::cout << std::endl;
	for(r2cf n(23,8); n.moreTerms(); std::cout << n.nextTerm() << " ");
	std::cout << std::endl;
	for(r2cf n(13,11); n.moreTerms(); std::cout << n.nextTerm() << " ");
	std::cout << std::endl;
	for(r2cf n(22,7); n.moreTerms(); std::cout << n.nextTerm() << " ");
	std::cout << std::endl;
	for(r2cf cf(-151,77); cf.moreTerms(); std::cout << cf.nextTerm() << " ");
	std::cout << std::endl;
	return 0;
}
