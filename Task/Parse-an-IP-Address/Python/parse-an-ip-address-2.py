import string
from pyparsing import * # import antigravity

tests="""#
127.0.0.1                       # The "localhost" IPv4 address
127.0.0.1:80                    # The "localhost" IPv4 address, with a specified port (80)
::1                             # The "localhost" IPv6 address
[::1]:80                        # The "localhost" IPv6 address, with a specified port (80)
2605:2700:0:3::4713:93e3        # Rosetta Code's primary server's public IPv6 address
[2605:2700:0:3::4713:93e3]:80   # Rosetta Code's primary server's public IPv6 address, +port (80)
2001:db8:85a3:0:0:8a2e:370:7334 # doc, IPv6 for 555-1234
2001:db8:85a3::8a2e:370:7334    # doc
[2001:db8:85a3:8d3:1319:8a2e:370:7348]:443 # doc +port
192.168.0.1                     # private
::ffff:192.168.0.1              # private transitional
::ffff:71.19.147.227            # Rosetta Code's transitional
[::ffff:71.19.147.227]:80       # Rosetta Code's transitional +port
::                              # unspecified
256.0.0.0                       # invalid, octet > 255 (currently not detected)
g::1                            # invalid
0000                                    Bad address
0000:0000                               Bad address
0000:0000:0000:0000:0000:0000:0000:0000 Good address
0000:0000:0000::0000:0000               Good Address
0000::0000::0000:0000                   Bad address
ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff Good address
ffff:ffff:ffff:fffg:ffff:ffff:ffff:ffff Bad address
fff:ffff:ffff:ffff:ffff:ffff:ffff:ffff  Good address
fff:ffff:0:ffff:ffff:ffff:ffff:ffff     Good address
"""

def print_args(args):
  print "print_args:", args

def join(args):
  args[0]="".join(args)
  del args[1:]

def replace(val):
  def lambda_replace(args):
    args[0]=val
    del args[1:]
  return lambda_replace

def atoi(args): args[0]=string.atoi(args[0])
def itohex2(args): args[0]="%02x"%args[0]

def hextoi(args): args[0]=string.atoi(args[0], 16)
def itohex4(args): args[0]="%04x"%args[0]

def assert_in_range(lwb, upb):
  def range_check(args):
    return # turn range checking off
    if args[0] < lwb:
      raise ValueError,"value %d < %d"%(args[0], lwb)
    if args[0] > upb:
      raise ValueError,"value %d > %d"%(args[0], upb)
  return range_check

dot = Literal(".").suppress()("dot"); colon = Literal(":").suppress()("colon")
octet = Word(nums).setParseAction(atoi,assert_in_range(0,255),itohex2)("octet");

port = Word(nums).setParseAction(atoi,assert_in_range(0,256*256-1))("port")
ipv4 = (octet + (dot+octet)*3)("addr")
ipv4.setParseAction(join) #,hextoi)

ipv4_port = ipv4+colon.suppress()+port

a2f = "abcdef"
hex = oneOf(" ".join(nums+a2f));

hexet = (hex*(0,4))("hexet")
hexet.setParseAction(join, hextoi, itohex4)

max=8; stop=max+1

xXXXX_etc = [None, hexet]; xXXXX_etc.extend([hexet + (colon+hexet)*n for n in range(1,max)])
x0000_etc = [ Literal("::").setParseAction(replace("0000"*num_x0000s)) for num_x0000s in range(stop) ]

ipv6=xXXXX_etc[-1]+x0000_etc[0] | xXXXX_etc[-1]

# Build a table of rules for IPv6, in particular the double colon
for num_prefix in range(max-1, -1, -1):
  for num_x0000s in range(0,stop-num_prefix):
    x0000 = x0000_etc[num_x0000s]
    num_suffix=max-num_prefix-num_x0000s
    if num_prefix:
      if num_suffix: pat = xXXXX_etc[num_prefix]+x0000+xXXXX_etc[num_suffix]
      else:          pat = xXXXX_etc[num_prefix]+x0000
    elif num_suffix: pat =                       x0000+xXXXX_etc[num_suffix]
    else: pat=x0000
    ipv6 = ipv6 | pat

ipv6.setParseAction(join) # ,hextoi)
ipv6_port = Literal("[").suppress() + ipv6 + Literal("]").suppress()+colon+port

ipv6_transitional = (Literal("::ffff:").setParseAction(replace("0"*20+"ffff"))+ipv4).setParseAction(join)
ipv6_transitional_port = Literal("[").suppress() + ipv6_transitional + Literal("]").suppress()+colon+port

ip_fmt = (
           (ipv4_port|ipv4)("ipv4") |
           (ipv6_transitional_port|ipv6_transitional|ipv6_port|ipv6)("ipv6")
         ) + LineEnd()

class IPAddr(object):
  def __init__(self, string):
    self.service = dict(zip(("address","port"), ip_fmt.parseString(string)[:]))
  def __getitem__(self, key): return self.service[key]
  def __contains__(self, key): return key in self.service
  def __repr__(self): return `self.service` # "".join(self.service)
  address=property(lambda self: self.service["address"])
  port=property(lambda self: self.service["port"])
  is_service=property(lambda self: "port" in self.service)
  version=property(lambda self: {False:4, True:6}[len(self.address)>8])

for test in tests.splitlines():
  if not test.startswith("#"):
    ip_str, desc = test.split(None,1)
    print ip_str,"=>",
    try:
      ip=IPAddr(ip_str)
      print ip, "IP Version:",ip.version,"- Address is OK!",
    except (ParseException,ValueError), details: print "Bad! IP address syntax error detected:",details,
    print "- Actually:",desc
