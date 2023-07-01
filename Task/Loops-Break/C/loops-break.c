int main(){
	time_t t;
	int a, b;
	srand((unsigned)time(&t));
	for(;;){
		a = rand() % 20;
		printf("%d\n", a);
		if(a == 10)
			break;
		b = rand() % 20;
		printf("%d\n", b);
	}
	return 0;
}
