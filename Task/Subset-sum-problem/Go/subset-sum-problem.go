package main

import "fmt"

type ww struct {
    word   string
    weight int
}

var input = []*ww{
    {"alliance", -624},
    {"archbishop", -915},
    {"balm", 397},
    {"bonnet", 452},
    {"brute", 870},
    {"centipede", -658},
    {"cobol", 362},
    {"covariate", 590},
    {"departure", 952},
    {"deploy", 44},
    {"diophantine", 645},
    {"efferent", 54},
    {"elysee", -326},
    {"eradicate", 376},
    {"escritoire", 856},
    {"exorcism", -983},
    {"fiat", 170},
    {"filmy", -874},
    {"flatworm", 503},
    {"gestapo", 915},
    {"infra", -847},
    {"isis", -982},
    {"lindholm", 999},
    {"markham", 475},
    {"mincemeat", -880},
    {"moresby", 756},
    {"mycenae", 183},
    {"plugging", -266},
    {"smokescreen", 423},
    {"speakeasy", -745},
    {"vein", 813},
}

type sss struct {
    subset []*ww
    sum    int
}

func main() {
    ps := []sss{{nil, 0}}
    for _, i := range input {
        pl := len(ps)
        for j := 0; j < pl; j++ {
            subset := append([]*ww{i}, ps[j].subset...)
            sum := i.weight + ps[j].sum
            if sum == 0 {
                fmt.Println("this subset sums to 0:")
                for _, i := range subset {
                    fmt.Println(*i)
                }
                return
            }
            ps = append(ps, sss{subset, sum})
        }
    }
    fmt.Println("no subset sums to 0")
}
