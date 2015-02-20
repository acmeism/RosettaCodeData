def commaQuibbling = { it.size() < 2 ? "{${it.join(', ')}}" : "{${it[0..-2].join(', ')} and ${it[-1]}}" }
