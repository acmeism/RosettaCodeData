class abs definition abstract.
  public section.
    methods method1 abstract importing iv_value type f exporting ev_ret type i.
  protected section.
    methods method2 abstract importing iv_name type string exporting ev_ret type i.
    methods add importing iv_a type i iv_b type i exporting ev_ret type i.
endclass.

class abs implementation.
  method add.
    ev_ret = iv_a + iv_b.
  endmethod.
endclass.
