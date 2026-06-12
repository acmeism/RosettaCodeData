from colored import Fore, Style
red: str = f'{Fore.rgb(255, 0, 0)}'
orange: str = f'{Fore.rgb(255, 128, 0)}'
yellow: str = f'{Fore.rgb(255, 255, 0)}'
green: str = f'{Fore.rgb(0, 255, 0)}'
blue: str = f'{Fore.rgb(0, 0, 255)}'
indigo: str = f'{Fore.rgb(75, 0, 130)}'
violet: str = f'{Fore.rgb(128, 0, 255)}'
print(f'{red}R{Style.reset}' + f'{orange}A{Style.reset}' + f'{yellow}I{Style.reset}' + f'{green}N{Style.reset}' + f'{blue}B{Style.reset}' + f'{indigo}O{Style.reset}' + f'{violet}W{Style.reset}')
