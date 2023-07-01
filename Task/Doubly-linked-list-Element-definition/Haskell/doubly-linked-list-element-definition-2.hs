class DoubleLink (value, prev_link, next_link)
  initially (value, prev_link, next_link)
    self.value := value
    self.prev_link := prev_link    # links are 'null' if not given
    self.next_link := next_link
end
