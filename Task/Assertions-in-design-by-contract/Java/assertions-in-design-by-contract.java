(...)
int feedForward(double[] inputs) {
    assert inputs.length == weights.length : "weights and input length mismatch";

    double sum = 0;
    for (int i = 0; i < weights.length; i++) {
        sum += inputs[i] * weights[i];
    }
    return activate(sum);
}
(...)
