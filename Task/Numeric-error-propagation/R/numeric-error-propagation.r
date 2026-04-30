#Plus-minus operator to generate uncertain numbers
`%+-%` <- function(x, sigma){
  if(!(is.numeric(x) & is.numeric(sigma))) stop("both arguments must be numeric")
  structure(list("num"=x, "err"=sigma), class="uncertain")
}

#Coercing floats (or integers) to uncertain numbers (not used here)
as.uncertain <- function(x) x%+-%0

#Operators for uncertain numbers
`+.uncertain` <- function(a, b){
  if(isa(a, "uncertain") & isa(b, "uncertain")){
    (a$num+b$num)%+-%sqrt(a$err^2+b$err^2)
  }
  else if(is.numeric(a)) b+a%+-%0
  else if(is.numeric(b)) a+b%+-%0
  else stop("non-numeric argument")
}

`-.uncertain` <- function(a, b){
  if(isa(a, "uncertain") & isa(b, "uncertain")){
    (a$num-b$num)%+-%sqrt(a$err^2+b$err^2)
  }
  else if(is.numeric(a)) b-a%+-%0
  else if(is.numeric(b)) a-b%+-%0
  else stop("non-numeric argument")
}

`*.uncertain` <- function(a, b){
  if(isa(a, "uncertain") & isa(b, "uncertain")){
    (a$num*b$num)%+-%a$num*b$num*sqrt((a$err/a$num)^2+(b$err/b$num)^2)
  }
  else if(is.numeric(a)) (b$num*a)%+-%abs(a*b$err)
  else if(is.numeric(b)) (a$num*b)%+-%abs(b*a$err)
  else stop("non-numeric argument")
}

`/.uncertain` <- function(a, b){
  if(isa(a, "uncertain") & isa(b, "uncertain")){
    (a$num/b$num)%+-%a$num*b$num*sqrt((a$err/a$num)^2+(b$err/b$num)^2)
  }
  else if(is.numeric(a)) (b$num/a)%+-%abs(b$err/a)
  else if(is.numeric(b)) (a$num/b)%+-%abs(a$err/b)
  else stop("non-numeric argument")
}

`^.uncertain` <- function(a,b){
  if(!is.numeric(b)) stop("exponent must be integer or double")
  (a$num^b)%+-%abs(b*a$err*a$num^(b-1))
}

#We need a print method to actually display uncertain numbers
print.uncertain <- function(x) cat(x$num, "+/-", x$err)

#The calculation
x1 <- 100%+-%1.1
y1 <- 50%+-%1.2
x2 <- 200%+-%2.2
y2 <- 100%+-%2.3

d <- print(((x1-x2)^2+(y1-y2)^2)^(1/2))
