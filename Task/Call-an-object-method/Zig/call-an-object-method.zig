const testing = @import("std").testing;

pub const ID = struct {
    name: []const u8,
    age: u7,

    const Self = @This();

    pub fn init(name: []const u8, age: u7) Self {
        return Self{
            .name = name,
            .age = age,
        };
    }

    pub fn getAge(self: Self) u7 {
        return self.age;
    }
};

test "call an object method" {
    // Declare an instance of a struct by using a struct method.
    const person1 = ID.init("Alice", 18);

    // Or by declaring it manually.
    const person2 = ID{
        .name = "Bob",
        .age = 20,
    };

    // test getAge() method call
    try testing.expectEqual(@as(u7, 18), person1.getAge());
    try testing.expectEqual(@as(u7, 20), ID.getAge(person2));
}
