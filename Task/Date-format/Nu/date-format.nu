let now = date now

['%F' '%A, %B %e, %Y'] | each {|fmt| $now | format date $fmt }
