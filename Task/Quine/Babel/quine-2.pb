% bin/babel
babel> { "{ '{ ' << dup [val 0x22 0xffffff00 ] dup <- << << -> << ' ' << << ' }' << } !" { '{ ' << dup [val 0x22 0xffffff00 ] dup <- << << -> << ' ' << << '}' << } ! }
babel> eval
{ "{ '{ ' << dup [val 0x22 0xffffff00 ] dup <- << << -> << ' ' << << ' }' << } !" { '{ ' << dup [val 0x22 0xffffff00 ] dup <- << << -> << ' ' << << '
}' << } !}babel>
babel>
