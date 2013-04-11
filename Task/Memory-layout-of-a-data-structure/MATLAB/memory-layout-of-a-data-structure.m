>> rs232 = struct('carrier_detect', logical(1),...
'received_data' , logical(1), ...
'transmitted_data', logical(1),...
'data_terminal_ready', logical(1),...
'signal_ground', logical(1),...
'data_set_ready', logical(1),...
'request_to_send', logical(1),...
'clear_to_send', logical(1),...
'ring_indicator', logical(1))

rs232 =

         carrier_detect: 1
          received_data: 1
       transmitted_data: 1
    data_terminal_ready: 1
          signal_ground: 1
         data_set_ready: 1
        request_to_send: 1
          clear_to_send: 1
         ring_indicator: 1

>> struct2cell(rs232)

ans =

    [1]
    [1]
    [1]
    [1]
    [1]
    [1]
    [1]
    [1]
    [1]
