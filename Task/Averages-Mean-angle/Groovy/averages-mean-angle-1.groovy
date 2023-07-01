import static java.lang.Math.*
def meanAngle = {
    atan2( it.sum { sin(it * PI / 180) } / it.size(), it.sum { cos(it * PI / 180) } / it.size()) * 180 / PI
}
