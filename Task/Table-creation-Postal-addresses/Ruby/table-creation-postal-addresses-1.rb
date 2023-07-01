require 'pstore'
require 'set'

Address = Struct.new :id, :street, :city, :state, :zip

db = PStore.new("addresses.pstore")
db.transaction do
  db[:next] ||= 0       # Next available Address#id
  db[:ids] ||= Set[]    # Set of all ids in db
end
