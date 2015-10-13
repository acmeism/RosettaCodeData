let
  example = // The member name in the object can either be the same as the parameter (as in bar, grill),
            // or a different parameter name as in the case of member foo being assigned to parameter a here.
    ({foo: a=0, bar=1, grill='pork chops'}={}) => (
      console.log('foo is ',a,', bar is ',bar,', and grill is '+grill));

example();
//  foo is 0 , bar is 1 , and grill is pork chops
example({grill: "lamb kebab", bar: 3.14});
//  foo is 0 , bar is 3.14 , and grill is lamb kebab
example({foo:null});
//  foo is , bar is 1 , and grill is pork chops
