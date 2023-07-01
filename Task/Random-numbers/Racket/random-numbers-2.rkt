#lang racket
(require math/distributions)
(sample (normal-dist 1.0 0.5) 1000)
