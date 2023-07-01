require 'drb/drb'

# The URI to connect to
SERVER_URI = "druby://localhost:8787"

# Start a local DRbServer to handle callbacks.
#
# Not necessary for this small example, but will be required
# as soon as we pass a non-marshallable object as an argument
# to a dRuby call.
DRb.start_service

timeserver = DRbObject.new_with_uri(SERVER_URI)
puts timeserver.get_current_time
