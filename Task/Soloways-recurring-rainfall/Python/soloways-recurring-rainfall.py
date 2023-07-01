import sys

def get_next_input():
    try:
        num = int(input("Enter rainfall int, 99999 to quit: "))
    except:
        print("Invalid input")
        return get_next_input()
    return num

current_average = 0.0
current_count = 0

while True:
    next = get_next_input()

    if next == 99999:
        sys.exit()
    else:
        current_count += 1
        current_average = current_average + (1.0/current_count)*next - (1.0/current_count)*current_average

        print("New average: ", current_average)
