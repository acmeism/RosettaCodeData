def main():
    resources = int(input("Number of resources: "))
    processes = int(input("Number of processes: "))
    max_resources = [int(i) for i in input("Maximum resources: ").split()]

    print("\n-- resources allocated for each process --")
    currently_allocated = [[int(i) for i in input(f"process {j + 1}: ").split()] for j in range(processes)]

    print("\n--- maximum resources for each process ---")
    max_need = [[int(i) for i in input(f"process {j + 1}: ").split()] for j in range(processes)]

    allocated = [0] * resources
    for i in range(processes):
        for j in range(resources):
            allocated[j] += currently_allocated[i][j]
    print(f"\nTotal resources allocated: {allocated}")

    available = [max_resources[i] - allocated[i] for i in range(resources)]
    print(f"Total resources available: {available}\n")

    running = [True] * processes
    count = processes
    while count != 0:
        safe = False
        for i in range(processes):
            if running[i]:
                executing = True
                for j in range(resources):
                    if max_need[i][j] - currently_allocated[i][j] > available[j]:
                        executing = False
                        break
                if executing:
                    print(f"process {i + 1} running")
                    running[i] = False
                    count -= 1
                    safe = True
                    for j in range(resources):
                        available[j] += currently_allocated[i][j]
                    break
        if not safe:
            print("The process is in an unsafe state.")
            break

        print(f"The process is in a safe state.\nAvailable resources: {available}\n\n")


if __name__ == '__main__':
    main()
