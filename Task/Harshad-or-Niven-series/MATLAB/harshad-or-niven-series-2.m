k=1; n=1;
while (k<=20)
	if isharshad(n)
		printf('%i ',n);
		k=k+1;
	end;
	n=n+1;
end
n = 1001;
while ~isharshad(n)
	n=n+1;
end;
printf('\nFirst harshad number larger than 1000 is %i\n',n);
