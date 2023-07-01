  fun {NewActiveSync Class Init}
     Obj = {New Class Init}
     MsgPort
  in
     thread MsgStream in
        {NewPort ?MsgStream ?MsgPort}
        for Msg#Sync in MsgStream do
           try
              {Obj Msg}
              Sync = unit
           catch E then
              Sync = {Value.failed E}
           end
        end
     end
     proc {$ Msg}
        Sync = {Port.sendRecv MsgPort Msg}
     in
        {Wait Sync}
     end
  end
