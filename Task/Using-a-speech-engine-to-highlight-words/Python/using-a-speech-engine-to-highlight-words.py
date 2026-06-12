import os


def speak(sentence: str, command="espeak"):
    words = sentence.split()
    os.system("clear")

    for i in range(len(words)):
        print("\033[0;0H")  # Move cursor to position (0, 0)
        print(
            " ".join(
                [
                    f"\033[1m{word.upper()}\033[0m" if j == i else word
                    for j, word in enumerate(words)
                ]
            )
        )

        os.system(f"espeak {words[i]}")


speak("Actions speak louder than words.")
