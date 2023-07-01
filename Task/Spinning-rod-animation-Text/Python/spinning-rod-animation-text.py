from time import sleep
while True:
    for rod in r'\|/-':
        print(rod, end='\r')
        sleep(0.25)
