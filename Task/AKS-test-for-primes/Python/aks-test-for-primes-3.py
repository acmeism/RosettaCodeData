print('''
{| class="wikitable" style="text-align:left;"
|+ Polynomial Expansions and AKS prime test
|-
! <math>p</math>
! <math>(x-1)^p</math>
|-''')
for p in range(12):
    print('! <math>%i</math>\n| <math>%s</math>\n| %r\n|-'
          % (p,
             ' '.join('%s%s' % (('%+i' % e) if (e != 1 or not p or (p and not n) ) else '+',
                                (('x^{%i}' % n) if n > 1 else 'x') if n else '')
                      for n,e in enumerate(expand_x_1(p))),
             aks_test(p)))
print('|}')
