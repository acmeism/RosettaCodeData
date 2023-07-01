import org.apache.commons.math3.special.Gamma.regularizedGammaQ

object ChiSquare extends App {
  private val dataSets: Seq[Seq[Double]] =
    Seq(
      Seq(199809, 200665, 199607, 200270, 199649),
      Seq(522573, 244456, 139979, 71531, 21461)
    )

  private def χ2IsUniform(data: Seq[Double], significance: Double) =
    χ2Prob(data.size - 1.0, χ2Dist(data)) > significance

  private def χ2Dist(data: Seq[Double]) = {
    val avg = data.sum / data.size

    data.reduce((a, b) => a + math.pow(b - avg, 2)) / avg
  }

  private def χ2Prob(dof: Double, distance: Double) =
    regularizedGammaQ(dof / 2, distance / 2)

  printf(" %4s %10s  %12s %8s   %s%n",
    "d.f.", "χ²distance", "χ²probability", "Uniform?", "dataset")
  dataSets.foreach { ds =>
    val (dist, dof) = (χ2Dist(ds), ds.size - 1)

    printf("%4d %11.3f  %13.8f    %5s    %6s%n",
      dof, dist, χ2Prob(dof.toDouble, dist), if (χ2IsUniform(ds, 0.05)) "YES" else "NO", ds.mkString(", "))
  }
}
