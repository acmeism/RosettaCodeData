function forest_fire(f,p,N,M)
% Forest fire
if nargin<4;
	M=200;
end
if nargin<3;
	N=200;
end
if nargin<2;
	p=.03;
end
if nargin<1;
	f=p*.0001;
end

% initialize;
F = (rand(M,N) < p)+1;  % tree with probability p
S = ones(3); S(2,2)=0;  % surrounding

textmap = ' T#';
colormap([.5,.5,.5;0,1,0;1,0,0]);
while(1)
	image(F); pause(.1)    % uncomment for graphical output
	% disp(textmap(F));	pause;		  % uncomment for textual output 		
	G = ((F==1).*((rand(M,N)<p)+1));  % grow tree
	G = G + (F==2) .* ((filter2(S,F==3)>0) + (rand(M,N)<f) + 2);  % burn tree if neighbor is burning or by chance f
	G = G + (F==3);						 % empty after burn
	F = G;
end;
