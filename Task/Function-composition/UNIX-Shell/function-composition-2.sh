#compose a new function consisting of the application of 2 unary functions

             compose () { f="$1"; g="$2"; x="$3"; "$f" "$("$g" "$x")";}


chartolowervowel()
# Usage:  chartolowervowel "A" --> "a"

#Based on a to_upper script in Chris F. A. Johnson's book Pro Bash Programming Ch7. String Manipulation
#(with minor tweaks to use local variables and return the value of the converted character
#http://cfajohnson.com/books/cfajohnson/pbp/
#highly recommended I have a copy and have bought another for a friend
{

   local LWR="";

	   case $1  in
                          A*) _LWR=a ;;
#                         B*) _LWR=b ;;
#			  C*) _LWR=c ;;
#			  D*) _LWR=d ;;
			  E*) _LWR=e ;;
#			  F*) _LWR=f ;;
#			  G*) _LWR=g ;;
#			  H*) _LWR=h ;;
			  I*) _LWR=i ;;
#			  J*) _LWR=j ;;
#			  K*) _LWR=k ;;
#			  L*) _LWR=L ;;
#			  M*) _LWR=m ;;
#			  N*) _LWR=n ;;
			  O*) _LWR=o ;;
#			  P*) _LWR=p ;;
#			  Q*) _LWR=q ;;
#			  R*) _LWR=r ;;
#			  S*) _LWR=s ;;
#			  T*) _LWR=t ;;
			  U*) _LWR=u ;;
#			  V*) _LWR=v ;;
#			  W*) _LWR=w ;;
#			  X*) _LWR=x ;;
#			  Y*) _LWR=y ;;
#			  Z*) _LWR=z ;;
			   *) _LWR=${1%${1#?}} ;;
		  esac;
		echo "$_LWR";
                               }

strdownvowel()
# Usage:  strdownvowel "STRING" --> "STRiNG"

#Based on an upword script in Chris F. A. Johnson's book Pro Bash Programming Ch7. String Manipulation
#(with minor tweaks to use local variables and return the value of the converted string
#http://cfajohnson.com/books/cfajohnson/pbp/
#highly recommended I have a copy and have bought another for a friend

{
  local _DWNWORD=""
  local word="$1"
  while [ -n "$word" ] ## loop until nothing is left in $word
  do
     chartolowervowel "$word" >> /dev/null
     _DWNWORD=$_DWNWORD$_LWR
     word=${word#?}  ## remove the first character from $word
	
  done
  Echo "$_DWNWORD"
}




chartoupper()
# Usage:  chartoupper "s" --> "S"

#From Chris F. A. Johnson's book Pro Bash Programming Ch7. String Manipulation
#(with minor tweaks to use local variables and return the value of the converted character
#http://cfajohnson.com/books/cfajohnson/pbp/
#highly recommended I have a copy and have bought another for a friend
 {
     local UPR="";
	
       case $1  in
                          a*) _UPR=A ;;
                          b*) _UPR=B ;;
			  c*) _UPR=C ;;
			  d*) _UPR=D ;;
			  e*) _UPR=E ;;
			  f*) _UPR=F ;;
			  g*) _UPR=G ;;
			  h*) _UPR=H ;;
			  i*) _UPR=I ;;
			  j*) _UPR=J ;;
			  k*) _UPR=K ;;
			  l*) _UPR=L ;;
			  m*) _UPR=M ;;
			  n*) _UPR=N ;;
			  o*) _UPR=O ;;
			  p*) _UPR=P ;;
			  q*) _UPR=Q ;;
			  r*) _UPR=R ;;
			  s*) _UPR=S ;;
			  t*) _UPR=T ;;
			  u*) _UPR=U ;;
			  v*) _UPR=V ;;
			  w*) _UPR=W ;;
			  x*) _UPR=X ;;
			  y*) _UPR=Y ;;
			  z*) _UPR=Z ;;
			   *) _UPR=${1%${1#?}} ;;
		  esac;
		echo "$_UPR";
		              }

strupcase()
# Usage:  strupcase "string" --> "STRING"

#Based on an upword script in Chris F. A. Johnson's book Pro Bash Programming Ch7. String Manipulation
#(with minor tweaks to use local variables and return the value of the converted string
#http://cfajohnson.com/books/cfajohnson/pbp/
#highly recommended I have a copy and have bought another for a friend

{
  local _UPWORD=""
  local word="$1"
  while [ -n "$word" ] ## loop until nothing is left in $word
  do
     chartoupper "$word" >> /dev/null
     _UPWORD=$_UPWORD$_UPR
     word=${word#?}  ## remove the first character from $word
	
  done
  Echo "$_UPWORD"
}

compose  strdownvowel strupcase "Cozy lummox gives smart squid who asks for job pen."
# --> CoZY LuMMoX GiVeS SMaRT SQuiD WHo aSKS FoR JoB PeN.
