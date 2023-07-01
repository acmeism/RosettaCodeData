dates = [
    ["May", 15],
    ["May", 16],
    ["May", 19],
    ["June", 17],
    ["June", 18],
    ["July", 14],
    ["July", 16],
    ["August", 14],
    ["August", 15],
    ["August", 17],
]

print dates.length, " remaining\n"

# the month cannot have a unique day
uniqueMonths = dates.group_by { |m,d| d }
                    .select { |k,v| v.size == 1 }
                    .map { |k,v| v.flatten }
                    .map { |m,d| m }
dates.delete_if { |m,d| uniqueMonths.include? m }
print dates.length, " remaining\n"

# the day must be unique
dates = dates   .group_by { |m,d| d }
                .select { |k,v| v.size == 1 }
                .map { |k,v| v.flatten }
print dates.length, " remaining\n"

# the month must now be unique
dates = dates   .group_by { |m,d| m }
                .select { |k,v| v.size == 1 }
                .map { |k,v| v }
                .flatten
print dates
