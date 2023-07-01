command_table_text = \
"""Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up"""

user_words = "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"

def find_abbreviations_length(command_table_text):
    """ find the minimal abbreviation length for each word by counting capital letters.
        a word that does not have capital letters gets it's full length as the minimum.
    """
    command_table = dict()
    for word in command_table_text.split():
        abbr_len = sum(1 for c in word if c.isupper())
        if abbr_len == 0:
            abbr_len = len(word)
        command_table[word] = abbr_len
    return command_table

def find_abbreviations(command_table):
    """ for each command insert all possible abbreviations"""
    abbreviations = dict()
    for command, min_abbr_len in command_table.items():
        for l in range(min_abbr_len, len(command)+1):
            abbr = command[:l].lower()
            abbreviations[abbr] = command.upper()
    return abbreviations

def parse_user_string(user_string, abbreviations):
    user_words = [word.lower() for word in user_string.split()]
    commands = [abbreviations.get(user_word, "*error*") for user_word in user_words]
    return " ".join(commands)

command_table = find_abbreviations_length(command_table_text)
abbreviations_table = find_abbreviations(command_table)

full_words = parse_user_string(user_words, abbreviations_table)

print("user words:", user_words)
print("full words:", full_words)
