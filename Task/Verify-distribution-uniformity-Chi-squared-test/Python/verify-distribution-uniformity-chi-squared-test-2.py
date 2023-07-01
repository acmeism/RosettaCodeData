from scipy.stats import chisquare


if __name__ == '__main__':
    dataSets = [[199809, 200665, 199607, 200270, 199649],
                [522573, 244456, 139979,  71531,  21461]]
    print(f"{'Distance':^12} {'pvalue':^12} {'Uniform?':^8} {'Dataset'}")
    for ds in dataSets:
        dist, pvalue = chisquare(ds)
        uni = 'YES' if pvalue > 0.05 else 'NO'
        print(f"{dist:12.3f} {pvalue:12.8f} {uni:^8} {ds}")
