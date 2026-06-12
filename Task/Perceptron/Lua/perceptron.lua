local Perceptron = {}
Perceptron.__index = Perceptron

function Perceptron.new(numInputs)
    local cell = {}
    setmetatable(cell, Perceptron)

    cell.weights = {}
    cell.bias = math.random()
    cell.output = 0

    for i = 1, numInputs do
        cell.weights[i] = math.random()
    end

    return cell
end

--used in both training and testing, calculates the output from inputs and weights
function Perceptron:update(inputs)
    local sum = self.bias
    for i = 1, #inputs do
        sum = sum + self.weights[i] * inputs[i]
    end
    self.output = sum
end

--returns the output from a given table of inputs
function Perceptron:test(inputs)
    self:update(inputs)
    return self.output
end

--used in training to adjust the weights and bias
function Perceptron:optimize(stepSize)
    local gradient = self.delta * self.output
    for i = 1, #self.weights do
        self.weights[i] = self.weights[i] + (stepSize*gradient)
    end
    self.bias = self.bias + (stepSize*self.delta)
end

--takes a table of training data, the number of iterations (or epochs) to train over, and the step size for training
function Perceptron:train(data, iterations, stepSize)
    for i = 1, iterations do
        for j = 1, #data do
            local datum = data[j]
            self:update(datum[1])
            self.delta = datum[2] - self.output
            self:optimize(stepSize)
        end
    end
end

local node = Perceptron.new(1) --creates a new Perceptron that takes in 1 input
local trainingData = {} --this Perceptron will be trained on the function y=2x+1
print("Untrained results:")
for i = -2, 2, 1 do
    print(i..":", node:test({i}))
    trainingData[i+3] = {{i},2*i+1} --the training data is a table, where each element is another table that has a table of inputs and one output
end
node:train(trainingData, 100, .1) --trains on the set for 100 epochs with a step size of 0.1
print("\nTrained results:")
for i = -2, 2, 1 do
    print(i..":", node:test({i}))
end
