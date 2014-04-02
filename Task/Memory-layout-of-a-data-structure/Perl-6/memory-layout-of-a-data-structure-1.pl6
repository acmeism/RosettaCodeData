enum T_RS232 <
    carrier_detect
    received_data
    transmitted_data
    data_terminal_ready
    signal_ground
    data_set_ready
    request_to_send
    clear_to_send
    ring_indicator
>;

my bit @signal[T_RS232];

@signal[signal_ground] = 1;
