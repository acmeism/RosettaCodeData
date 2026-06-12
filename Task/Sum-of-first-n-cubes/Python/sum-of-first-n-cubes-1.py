def main():
    fila = 0
    lenCubos = 51

    print("Suma de N cubos para n = [0..49]\n")

    for n in range(1, lenCubos):
        sumCubos = 0
        for m in range(1, n):
            sumCubos = sumCubos + (m ** 3)

        fila += 1
        print(f'{sumCubos:7} ', end='')
        if fila % 5 == 0:
            print(" ")

    print(f"\nEncontrados {fila} cubos.")

if __name__ == '__main__': main()
