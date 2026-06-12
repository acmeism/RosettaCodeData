import random

TRAINING_LENGTH = 2000

class Perceptron:
    '''Simple one neuron simulated neural network'''
    def __init__(self,n):
        self.c = .01
        self.weights = [random.uniform(-1.0, 1.0) for _ in range(n)]

    def feed_forward(self, inputs):
        weighted_inputs = []
        for i in range(len(inputs)):
            weighted_inputs.append(inputs[i] * self.weights[i])
        return self.activate(sum(weighted_inputs))

    def activate(self, value):
        return 1 if value > 0 else -1

    def train(self, inputs, desired):
        guess = self.feed_forward(inputs)
        error = desired - guess
        for i in range(len(inputs)):
            self.weights[i] += self.c * error * inputs[i]

class Trainer():
    ''' '''
    def __init__(self, x, y, a):
        self.inputs = [x, y, 1]
        self.answer = a

def F(x):
    return 2 * x + 1

if __name__ == "__main__":
    ptron = Perceptron(3)
    training = []
    for i in range(TRAINING_LENGTH):
        x = random.uniform(-10,10)
        y = random.uniform(-10,10)
        answer = 1
        if y < F(x): answer = -1
        training.append(Trainer(x,y,answer))
    result = []
    for y in range(-10,10):
        temp = []
        for x in range(-10,10):
            if ptron.feed_forward([x,y,1]) == 1:
                temp.append('^')
            else:
                temp.append('.')
        result.append(temp)

    print('Untrained')
    for row in result:
        print(''.join(v for v in row))

    for t in training:
        ptron.train(t.inputs, t.answer)

    result = []
    for y in range(-10,10):
        temp = []
        for x in range(-10,10):
            if ptron.feed_forward([x,y,1]) == 1:
                temp.append('^')
            else:
                temp.append('.')
        result.append(temp)

    print('Trained')
    for row in result:
        print(''.join(v for v in row))
