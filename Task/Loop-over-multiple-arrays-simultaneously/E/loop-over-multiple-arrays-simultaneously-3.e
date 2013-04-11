def zip {
  to run(l1, l2) {
    def zipped {
      to iterate(f) {
        for i in int >= 0 {
          f(i, [l1.fetch(i, fn { return }),
                l2.fetch(i, fn { return })])
        }
      }
    }
    return zipped
  }

  match [`run`, lists] {
    def zipped {
      to iterate(f) {
        for i in int >= 0 {
          var tuple := []
          for l in lists {
            tuple with= l.fetch(i, fn { return })
          }
          f(i, tuple)
        }
      }
    }
    zipped
  }
}
