const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

// Forward declarations
const Body = struct {};
const Engine = struct {};
const Wheel = struct {
    name: []const u8,

    const Self = @This();

    pub fn init(name: []const u8) Self {
        return Self{ .name = name };
    }

    pub fn getName(self: *const Self) []const u8 {
        return self.name;
    }
};

const Car = struct {
    elements: ArrayList(CarElement),
    allocator: Allocator,

    const Self = @This();

    pub fn init(allocator: Allocator) !Self {
        var elements = ArrayList(CarElement).init(allocator);

        // Add wheels
        try elements.append(CarElement{ .wheel = Wheel.init("front left") });
        try elements.append(CarElement{ .wheel = Wheel.init("front right") });
        try elements.append(CarElement{ .wheel = Wheel.init("back left") });
        try elements.append(CarElement{ .wheel = Wheel.init("back right") });

        // Add body and engine
        try elements.append(CarElement{ .body = Body{} });
        try elements.append(CarElement{ .engine = Engine{} });

        return Self{
            .elements = elements,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Self) void {
        self.elements.deinit();
    }
};

// Tagged union to represent different car elements
const CarElement = union(enum) {
    body: Body,
    engine: Engine,
    wheel: Wheel,
    car: Car,

    const Self = @This();

    pub fn accept(self: *const Self, visitor: *CarElementVisitor) void {
        switch (self.*) {
            .body => |*body| visitor.visitBody(body),
            .engine => |*engine| visitor.visitEngine(engine),
            .wheel => |*wheel| visitor.visitWheel(wheel),
            .car => |*car| {
                // Visit all elements first
                for (car.elements.items) |*element| {
                    element.accept(visitor);
                }
                // Then visit the car itself
                visitor.visitCar(car);
            },
        }
    }
};

// Visitor interface using function pointers
const CarElementVisitor = struct {
    visitBodyFn: *const fn (visitor: *CarElementVisitor, body: *const Body) void,
    visitEngineFn: *const fn (visitor: *CarElementVisitor, engine: *const Engine) void,
    visitWheelFn: *const fn (visitor: *CarElementVisitor, wheel: *const Wheel) void,
    visitCarFn: *const fn (visitor: *CarElementVisitor, car: *const Car) void,

    const Self = @This();

    pub fn visitBody(self: *Self, body: *const Body) void {
        self.visitBodyFn(self, body);
    }

    pub fn visitEngine(self: *Self, engine: *const Engine) void {
        self.visitEngineFn(self, engine);
    }

    pub fn visitWheel(self: *Self, wheel: *const Wheel) void {
        self.visitWheelFn(self, wheel);
    }

    pub fn visitCar(self: *Self, car: *const Car) void {
        self.visitCarFn(self, car);
    }
};

// Concrete visitor implementations
const CarElementDoVisitor = struct {
    visitor: CarElementVisitor,

    const Self = @This();

    pub fn init() Self {
        return Self{
            .visitor = CarElementVisitor{
                .visitBodyFn = visitBodyImpl,
                .visitEngineFn = visitEngineImpl,
                .visitWheelFn = visitWheelImpl,
                .visitCarFn = visitCarImpl,
            },
        };
    }

    fn visitBodyImpl(visitor: *CarElementVisitor, _: *const Body) void {
        _ = visitor; // unused parameter
        print("Moving my body.\n" , .{});
    }

    fn visitEngineImpl(visitor: *CarElementVisitor, _: *const Engine) void {
        _ = visitor; // unused parameter
        print("Starting my engine.\n" , .{});
    }

    fn visitWheelImpl(visitor: *CarElementVisitor, wheel: *const Wheel) void {
        _ = visitor; // unused parameter
        print("Kicking my {s} wheel.\n", .{wheel.getName()});
    }

    fn visitCarImpl(visitor: *CarElementVisitor, _: *const Car) void {
        _ = visitor; // unused parameter
        print("Starting my car.\n" , .{});
    }
};

const CarElementPrintVisitor = struct {
    visitor: CarElementVisitor,

    const Self = @This();

    pub fn init() Self {
        return Self{
            .visitor = CarElementVisitor{
                .visitBodyFn = visitBodyImpl,
                .visitEngineFn = visitEngineImpl,
                .visitWheelFn = visitWheelImpl,
                .visitCarFn = visitCarImpl,
            },
        };
    }

    fn visitBodyImpl(visitor: *CarElementVisitor, _: *const Body) void {
        _ = visitor; // unused parameter
        print("Visiting body.\n" , .{});
    }

    fn visitEngineImpl(visitor: *CarElementVisitor, _: *const Engine) void {
        _ = visitor; // unused parameter
        print("Visiting my engine.\n", .{});
    }

    fn visitWheelImpl(visitor: *CarElementVisitor, wheel: *const Wheel) void {
        _ = visitor; // unused parameter
        print("Visiting my {s} wheel.\n", .{wheel.getName()});
    }

    fn visitCarImpl(visitor: *CarElementVisitor, _: *const Car) void {
        _ = visitor; // unused parameter
        print("Visiting car.\n", .{});
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var car = try Car.init(allocator);
    defer car.deinit();

    const car_element = CarElement{ .car = car };

    var print_visitor = CarElementPrintVisitor.init();
    car_element.accept(&print_visitor.visitor);

    var do_visitor = CarElementDoVisitor.init();
    car_element.accept(&do_visitor.visitor);
}
