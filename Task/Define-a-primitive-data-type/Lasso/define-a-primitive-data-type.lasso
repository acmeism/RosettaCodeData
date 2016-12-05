define dint => type {
   data private value

   public oncreate(value::integer) => {
	fail_if(#value < 1,#value+' less than 1 ')
	fail_if(#value > 10,#value+' greater than 10')
	.value = #value
   }

   public +(rhs::integer) => dint(.value + #rhs)
   public -(rhs::integer) => dint(.value - #rhs)
   public *(rhs::integer) => dint(.value * #rhs)
   public /(rhs::integer) => dint(.value / #rhs)
   public %(rhs::integer) => dint(.value % #rhs)

   public asstring() => string(.value)

}

dint(1) // 1
dint(10) // 10

dint(0) // Error: 0 less than 1
dint(2) - 5 // Error: -3 less than 1

dint(11) // Error: 11 greater than 10
dint(10) + 1 // Error: 11 greater than 10
dint(10) * 2 // Error: 20 greater than 10
