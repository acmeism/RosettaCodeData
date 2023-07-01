double chi2UniformDistance( double *ds, int dslen)
{
    double expected = 0.0;
    double sum = 0.0;
    int k;

    for (k=0; k<dslen; k++)
        expected += ds[k];
    expected /= k;

    for (k=0; k<dslen; k++) {
        double x = ds[k] - expected;
        sum += x*x;
    }
    return sum/expected;
}

double chi2Probability( int dof, double distance)
{
    return GammaIncomplete_Q( 0.5*dof, 0.5*distance);
}

int chiIsUniform( double *dset, int dslen, double significance)
{
    int dof = dslen -1;
    double dist = chi2UniformDistance( dset, dslen);
    return chi2Probability( dof, dist ) > significance;
}
