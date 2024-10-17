// In this example, the can_register method has a receiver of type 'User' named 'u'.

struct User {
	age int
}

// 'can_register' is a method of the 'User' struct above

fn (u User) can_register() bool {
	return u.age > 16
}

user := User{
	age: 10
}
println(user.can_register()) // "false"

user2 := User{
	age: 20
}
println(user2.can_register()) // "true"
