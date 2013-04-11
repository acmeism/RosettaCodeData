PROGRAM KNAPSACK

  IMPLICIT NONE

  REAL :: totalWeight, totalVolume
  INTEGER :: maxPanacea, maxIchor, maxGold, maxValue = 0
  INTEGER :: i, j, k
  INTEGER :: n(3)

  TYPE Bounty
    INTEGER :: value
    REAL :: weight
    REAL :: volume
  END TYPE Bounty

  TYPE(Bounty) :: panacea, ichor, gold, sack, current

  panacea = Bounty(3000, 0.3, 0.025)
  ichor   = Bounty(1800, 0.2, 0.015)
  gold    = Bounty(2500, 2.0, 0.002)
  sack    = Bounty(0, 25.0, 0.25)

  maxPanacea = MIN(sack%weight / panacea%weight, sack%volume / panacea%volume)
  maxIchor = MIN(sack%weight / ichor%weight, sack%volume / ichor%volume)
  maxGold = MIN(sack%weight / gold%weight, sack%volume / gold%volume)

  DO i = 0, maxPanacea
     DO j = 0, maxIchor
        Do k = 0, maxGold
           current%value = k * gold%value + j * ichor%value + i * panacea%value
           current%weight = k * gold%weight + j * ichor%weight + i * panacea%weight
           current%volume = k * gold%volume + j * ichor%volume + i * panacea%volume
           IF (current%weight > sack%weight .OR. current%volume > sack%volume) CYCLE
           IF (current%value > maxValue) THEN
              maxValue = current%value
              totalWeight = current%weight
              totalVolume = current%volume
              n(1) = i ; n(2) = j ; n(3) = k
           END IF
        END DO
     END DO
  END DO

  WRITE(*, "(A,I0)") "Maximum value achievable is ", maxValue
  WRITE(*, "(3(A,I0),A)") "This is achieved by carrying ", n(1), " panacea, ", n(2), " ichor and ", n(3), " gold items"
  WRITE(*, "(A,F4.1,A,F5.3)") "The weight to carry is ", totalWeight, " and the volume used is ", totalVolume

END PROGRAM KNAPSACK
