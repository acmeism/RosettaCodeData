import subprocess

def main():
    freq = 0

    while freq < 40 or freq > 10000:
        try:
            freq = int(input("Enter frequency in Hz (40 to 10000) : "))
        except ValueError as e:
            print(e)

    vol = 0

    while vol < 1 or vol > 50:
        try:
            vol = int(input("Enter volume in dB (1 to 50) : "))
        except ValueError as e:
            print(e)

    dur = 0

    while dur < 2 or dur > 10:
        try:
            dur = int(input("Enter duration in seconds (2 to 10) : "))
        except ValueError as e:
            print(e)

    kind = 0

    while kind < 1 or kind > 3:
        try:
            kind = int(input("Enter kind (1 = Sine, 2 = Square, 3 = Sawtooth) : "))
        except ValueError as e:
            print(e)

    kind_str = 'sine'

    if kind == 2:
        kind_str = 'square'
    elif kind == 3:
        kind_str = 'sawtooth'

    subprocess.call(['play', '-n', 'synth', f'{dur:g}', kind_str, str(freq), "vol", str(vol), "dB"])

if __name__ == '__main__':
    main()
