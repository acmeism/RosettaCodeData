dependencies=: noun define
  top1    des1 ip1 ip2
  top2    des1 ip2 ip3
  ip1     extra1 ip1a ipcommon
  ip2     ip2a ip2b ip2c ipcommon
  des1    des1a des1b des1c
  des1a   des1a1 des1a2
  des1c   des1c1 extra1
)

   >topLevel dependencies
top1
top2

   ;:inv@> 'top1' compileOrder dependencies
extra1 ip1a ipcommon ip2a ip2b ip2c des1b des1a1 des1a2 des1c1
ip1 ip2 des1a des1c
des1
top1

   ;:inv@> 'top2' compileOrder dependencies
ip3 extra1 ipcommon ip2a ip2b ip2c des1b des1a1 des1a2 des1c1
ip2 des1a des1c
des1
top2

   ;:inv@> 'top1 top2' compileOrder dependencies
ip3 extra1 ip1a ipcommon ip2a ip2b ip2c des1b des1a1 des1a2 des1c1
ip1 ip2 des1a des1c
des1
top1 top2
