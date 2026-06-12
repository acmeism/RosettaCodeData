const std = @import("std");
const Thread = std.Thread;
const Mutex = Thread.Mutex;
const Condition = Thread.Condition;
const Allocator = std.mem.Allocator;
const HashMap = std.AutoHashMap;
const Random = std.rand.Random;

// Define constants for state representation
const OUTSIDE: i32 = 0;
const WAITING_ROOM: i32 = 1;
const WAITING_FOR_OTHERS: i32 = 2;
const DOORWAY: i32 = 3;
const IN_CRITICAL_SECTION: i32 = 4;

const FlagsState = struct {
    mutex: Mutex,
    cond: Condition,
    flags: HashMap(i32, i32),

    fn init(allocator: Allocator) FlagsState {
        return .{
            .mutex = .{},
            .cond = .{},
            .flags = HashMap(i32, i32).init(allocator),
        };
    }

    fn deinit(self: *FlagsState) void {
        self.flags.deinit();
    }
};

const SharedState = struct {
    all_szy: []const i32,
    flags_state: *FlagsState,
    critical_value: *SharedInt,
};

const SharedInt = struct {
    mutex: Mutex,
    value: i32,

    fn init(value: i32) SharedInt {
        return .{
            .mutex = .{},
            .value = value,
        };
    }
};

fn runSzymanski(id: i32, shared_state: SharedState) !void {
    // Filter out others
    var others = std.ArrayList(i32).init(std.heap.c_allocator);
    defer others.deinit();

    for (shared_state.all_szy) |other_id| {
        if (other_id != id) {
            try others.append(other_id);
        }
    }

    // Standing outside waiting room
    {
        shared_state.flags_state.mutex.lock();
        defer shared_state.flags_state.mutex.unlock();

        try shared_state.flags_state.flags.put(id, WAITING_ROOM);
        shared_state.flags_state.cond.broadcast();
    }

    // Wait until no other process is in or passing through the doorway
    while (true) {
        var should_wait = false;

        shared_state.flags_state.mutex.lock();
        for (others.items) |other_id| {
            if (shared_state.flags_state.flags.get(other_id)) |flag| {
                if (flag >= DOORWAY) {
                    should_wait = true;
                    break;
                }
            }
        }
        shared_state.flags_state.mutex.unlock();

        if (!should_wait) break;
        std.time.sleep(1); // yield
    }

    // Standing in doorway
    {
        shared_state.flags_state.mutex.lock();
        defer shared_state.flags_state.mutex.unlock();

        try shared_state.flags_state.flags.put(id, DOORWAY);
        shared_state.flags_state.cond.broadcast();
    }

    // Check if other processes are still waiting
    var others_waiting = false;
    {
        shared_state.flags_state.mutex.lock();
        defer shared_state.flags_state.mutex.unlock();

        for (others.items) |other_id| {
            if (shared_state.flags_state.flags.get(other_id)) |flag| {
                if (flag == WAITING_ROOM) {
                    others_waiting = true;
                    break;
                }
            }
        }
    }

    if (others_waiting) {
        // Waiting for other processes to enter
        {
            shared_state.flags_state.mutex.lock();
            defer shared_state.flags_state.mutex.unlock();

            try shared_state.flags_state.flags.put(id, WAITING_FOR_OTHERS);
            shared_state.flags_state.cond.broadcast();
        }

        // Wait for other processes to close the door
        while (true) {
            var should_continue = true;

            shared_state.flags_state.mutex.lock();
            for (others.items) |other_id| {
                if (shared_state.flags_state.flags.get(other_id)) |flag| {
                    if (flag == IN_CRITICAL_SECTION) {
                        should_continue = false;
                        break;
                    }
                }
            }
            shared_state.flags_state.mutex.unlock();

            if (!should_continue) break;
            std.time.sleep(1); // yield
        }
    }

    // The door is closed
    {
        shared_state.flags_state.mutex.lock();
        defer shared_state.flags_state.mutex.unlock();

        try shared_state.flags_state.flags.put(id, IN_CRITICAL_SECTION);
        shared_state.flags_state.cond.broadcast();
    }

    // Wait for lower numbered processes
    for (others.items) |other_id| {
        if (other_id >= id) continue;

        while (true) {
            var should_wait = false;

            shared_state.flags_state.mutex.lock();
            if (shared_state.flags_state.flags.get(other_id)) |flag| {
                if (flag > WAITING_ROOM) {
                    should_wait = true;
                }
            }
            shared_state.flags_state.mutex.unlock();

            if (!should_wait) break;
            std.time.sleep(1); // yield
        }
    }

    // Critical section
    {
        shared_state.critical_value.mutex.lock();
        defer shared_state.critical_value.mutex.unlock();

        shared_state.critical_value.value += id * 3;
        shared_state.critical_value.value /= 2;
        std.debug.print("Thread {} changed the critical value to {}.\n", .{id, shared_state.critical_value.value});
    }

    // Exit protocol
    for (others.items) |other_id| {
        if (other_id <= id) continue;

        while (true) {
            var should_wait = true;

            shared_state.flags_state.mutex.lock();
            if (shared_state.flags_state.flags.get(other_id)) |flag| {
                if (flag == OUTSIDE or flag == WAITING_ROOM or flag == IN_CRITICAL_SECTION) {
                    should_wait = false;
                }
            }
            shared_state.flags_state.mutex.unlock();

            if (!should_wait) break;
            std.time.sleep(1); // yield
        }
    }

    // Leave
    {
        shared_state.flags_state.mutex.lock();
        defer shared_state.flags_state.mutex.unlock();

        try shared_state.flags_state.flags.put(id, OUTSIDE);
        shared_state.flags_state.cond.broadcast();
    }
}

fn testSzymanski(n: i32) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Create array of thread IDs
    var all_szy = try allocator.alloc(i32, @as(usize, @intCast(n)));
    for (0..@as(usize, @intCast(n))) |i| {
        all_szy[i] = @as(i32, @intCast(i + 1));
    }

    var flags_state = try allocator.create(FlagsState);
    flags_state.* = FlagsState.init(allocator);
    defer flags_state.deinit();

    const critical_value = try allocator.create(SharedInt);
    critical_value.* = SharedInt.init(1);

    const shared_state = SharedState{
        .all_szy = all_szy,
        .flags_state = flags_state,
        .critical_value = critical_value,
    };

    // Create and start threads
    var threads = try allocator.alloc(Thread, @as(usize, @intCast(n)));

    for (0..@as(usize, @intCast(n))) |i| {
        const thread_id = @as(i32, @intCast(i + 1));
        threads[i] = try Thread.spawn(.{}, runSzymanski, .{thread_id, shared_state});
    }

    // Wait for all threads to complete
    for (threads) |thread| {
        thread.join();
    }
}

pub fn main() !void {
    try testSzymanski(20);
}
