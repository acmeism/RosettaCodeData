# Project : Dutch national flag problem

flag = ["Red","White","Blue"]
balls = list(10)

see "Random: |"
for i = 1 to 10
     color = random(2) + 1
     balls[i] = flag[color]
     see  balls[i] + " |"
next
see nl

see "Sorted: |"
for i = 1 to 3
     color = flag[i]
     for j = 1 to 10
          if balls[j] = color
             see balls[j] + " |"
          ok
     next
next
