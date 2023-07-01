let isPangram (str: string) = (set['a'..'z'] - set(str.ToLower())).IsEmpty
