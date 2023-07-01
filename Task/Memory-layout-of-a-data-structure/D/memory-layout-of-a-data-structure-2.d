import std.bitmanip;

struct RS232_data {
    static if (std.system.endian == std.system.Endian.bigEndian) {
        mixin(bitfields!(bool, "carrier_detect",      1,
                         bool, "received_data",       1,
                         bool, "transmitted_data",    1,
                         bool, "data_terminal_ready", 1,
                         bool, "signal_ground",       1,
                         bool, "data_set_ready",      1,
                         bool, "request_to_send",     1,
                         bool, "clear_to_send",       1,
                         bool, "ring_indicator",      1,
                         bool, "",                    7));
    } else {
        mixin(bitfields!(bool, "",                    7,
                         bool, "ring_indicator",      1,
                         bool, "clear_to_send",       1,
                         bool, "request_to_send",     1,
                         bool, "data_set_ready",      1,
                         bool, "signal_ground",       1,
                         bool, "data_terminal_ready", 1,
                         bool, "transmitted_data",    1,
                         bool, "received_data",       1,
                         bool, "carrier_detect",      1));
    }

    static assert(RS232_data.sizeof == 2);
}

void main() {}
