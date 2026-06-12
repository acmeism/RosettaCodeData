package main

import (
    "github.com/fogleman/gg"
    "math/rand"
    "time"
)

const c = 0.00001

func linear(x float64) float64 {
    return x*0.7 + 40
}

type trainer struct {
    inputs []float64
    answer int
}

func newTrainer(x, y float64, a int) *trainer {
    return &trainer{[]float64{x, y, 1}, a}
}

type perceptron struct {
    weights  []float64
    training []*trainer
}

func newPerceptron(n, w, h int) *perceptron {
    weights := make([]float64, n)
    for i := 0; i < n; i++ {
        weights[i] = rand.Float64()*2 - 1
    }

    training := make([]*trainer, 2000)
    for i := 0; i < 2000; i++ {
        x := rand.Float64() * float64(w)
        y := rand.Float64() * float64(h)
        answer := 1
        if y < linear(x) {
            answer = -1
        }
        training[i] = newTrainer(x, y, answer)
    }
    return &perceptron{weights, training}
}

func (p *perceptron) feedForward(inputs []float64) int {
    if len(inputs) != len(p.weights) {
        panic("weights and input length mismatch, program terminated")
    }
    sum := 0.0
    for i, w := range p.weights {
        sum += inputs[i] * w
    }
    if sum > 0 {
        return 1
    }
    return -1
}

func (p *perceptron) train(inputs []float64, desired int) {
    guess := p.feedForward(inputs)
    err := float64(desired - guess)
    for i := range p.weights {
        p.weights[i] += c * err * inputs[i]
    }
}

func (p *perceptron) draw(dc *gg.Context, iterations int) {
    le := len(p.training)
    for i, count := 0, 0; i < iterations; i, count = i+1, (count+1)%le {
        p.train(p.training[count].inputs, p.training[count].answer)
    }
    x := float64(dc.Width())
    y := linear(x)
    dc.SetLineWidth(2)
    dc.SetRGB255(0, 0, 0) // black line
    dc.DrawLine(0, linear(0), x, y)
    dc.Stroke()
    dc.SetLineWidth(1)
    for i := 0; i < le; i++ {
        guess := p.feedForward(p.training[i].inputs)
        x := p.training[i].inputs[0] - 4
        y := p.training[i].inputs[1] - 4
        if guess > 0 {
            dc.SetRGB(0, 0, 1) // blue circle
        } else {
            dc.SetRGB(1, 0, 0) // red circle
        }
        dc.DrawCircle(x, y, 8)
        dc.Stroke()
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    w, h := 640, 360
    perc := newPerceptron(3, w, h)
    dc := gg.NewContext(w, h)
    dc.SetRGB(1, 1, 1) // white background
    dc.Clear()
    perc.draw(dc, 2000)
    dc.SavePNG("perceptron.png")
}
