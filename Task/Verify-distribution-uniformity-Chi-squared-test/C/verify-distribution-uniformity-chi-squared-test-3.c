int main(int argc, char **argv)
{
    double dset1[] = { 199809., 200665., 199607., 200270., 199649. };
    double dset2[] = { 522573., 244456., 139979.,  71531.,  21461. };
    double *dsets[] = { dset1, dset2 };
    int     dslens[] = { 5, 5 };
    int k, l;
    double  dist, prob;
    int dof;

    for (k=0; k<2; k++) {
        printf("Dataset: [ ");
        for(l=0;l<dslens[k]; l++)
            printf("%.0f, ", dsets[k][l]);

        printf("]\n");
        dist = chi2UniformDistance(dsets[k], dslens[k]);
        dof = dslens[k]-1;
        printf("dof: %d  distance: %.4f", dof, dist);
        prob = chi2Probability( dof, dist );
        printf(" probability: %.6f", prob);
        printf(" uniform? %s\n", chiIsUniform(dsets[k], dslens[k], 0.05)? "Yes":"No");
    }
    return 0;
}
