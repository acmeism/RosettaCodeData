# Use the default printer queue, with lp(1) or lpr(1).
#  1. The system must have a printer queue.
#  2. The printer queue must understand plain text.
#  3. System V has lp(1). BSD has lpr(1).
#     CUPS has both lp(1) and lpr(1).
#
echo 'Hello World!' | lp
echo 'Hello World!' | lpr

# Use a character device.
#  1. The device must understand plain text.
#  2. You must have write permission for the device.
#  3. Some systems have /dev/lp0, /dev/lp1, ...
#  4. BSD has /dev/lpt0, /dev/lpt1, ... for the parallel ports;
#     and /dev/ulpt0, /dev/ulpt1, ... for the USB printers.
# Note that intermingling can occur if two processes write to the device at the
# same time. Using the print spooler method above avoids this problem,
#
echo 'Hello World!' >/dev/lp0
echo 'Hello World!' >/dev/lpt0
echo 'Hello World!' >/dev/ulpt0
