try: raw_input
except: raw_input = input

print(sum(map(int, raw_input().split())))
