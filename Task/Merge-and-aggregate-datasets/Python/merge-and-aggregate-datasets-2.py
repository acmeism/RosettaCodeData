import csv

fnames = 'patients.csv  patients_visits.csv'.split()

def csv2list(fname):
    with open(fname) as f:
        rows = list(csv.reader(f))
    return rows

patients, visits = data = [csv2list(fname) for fname in fnames]
result = [record.copy() for record in patients]
result[1:] = sorted(result[1:])
#%%
result[0].append('LAST_VISIT')
last = {p: vis for p, vis, *score in visits[1:]}
for record in result[1:]:
    p = record[0]
    record.append(last.get(p, ''))
#%%
result[0] += ['SCORE_SUM', 'SCORE_AVG']
n = {p: 0 for p, *_ in patients[1:]}
tot = n.copy()
for record in visits[1:]:
    p, _, score = record
    if score:
        n[p] += 1
        tot[p] += float(score)
for record in result[1:]:
    p = record[0]
    if n[p]:
        record += [f"{tot[p]:5.1f}", f"{tot[p] / n[p]:5.2f}"]
    else:
        record += ['', '']
#%%
for record in result:
    print(f"| {' | '.join(f'{r:^10}' for r in record)} |")
