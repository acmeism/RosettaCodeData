#!/bin/bash

# variable declaration
typeset -i BoardSize=8
typeset -i p=0
typeset -i total=0
typeset -i board

# initialization
function init
{
    for (( i=0;i<$BoardSize;i++ ))
    do
        (( board[$i]=-1 ))
    done
}

# check if queen can be placed
function place
{
        typeset -i flag=1
        for (( i=0;i<$1;i++ ))
        do
                if [[ (${board[$i]}-${board[$1]} -eq ${i}-${1}) || (${board[$i]}-${board[$1]} -eq ${1}-${i}) || (${board[$i]} -eq ${board[$1]}) ]]
                then
                        (( flag=0 ))
                fi
        done
        [[ $flag -eq 0 ]]
        return $?
}

# print the result
function out
{
        printf "Problem of queen %d:%d\n" $BoardSize $total
}

# free the variables
function depose
{
    unset p
    unset total
    unset board
    unset BoardSize
}

# back tracing
function work
{
    while [[ $p -gt -1 ]]
        do
        (( board[$p]++ ))
        if  [[ ${board[$p]} -ge ${BoardSize} ]]
        then  # back tracing
            (( p-- ))
        else  # try next position
            place $p
            if [[ $? -eq 1 ]]
            then
                (( p++ ))
                if [[ $p -ge ${BoardSize} ]]
                then
                    (( total++ ))
                    (( p-- ))
                else
                    (( board[$p]=-1 ))
                fi
            fi
        fi
    done
}

# entry
init
work
out
depose
