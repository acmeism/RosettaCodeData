try: raw_input
except: raw_input = input

print(sum(int(x) for x in raw_input().split()))
