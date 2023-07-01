report z_accumulator
class acc definition.
  public section.
    methods:
      call importing iv_i type any default 0 exporting ev_r type any,
      constructor importing iv_d type f.
  private section.
    data a_sum type f.
endclass.

class acc implementation.
  method call.
      add iv_i to a_sum.
      ev_r = a_sum.
  endmethod.

start-of-selection.

data: cl_acc type ref to acc,
      lv_ret2 type f,
      lv_ret1 type i.

create object cl_acc exporting iv_d = 1.
cl_acc->call( exporting iv_i = 5 ).
cl_acc->call( exporting iv_i = '2.3' importing ev_r = lv_ret2 ).
cl_acc->call( exporting iv_i = 2 importing ev_r = lv_ret1 ).
write : / lv_ret2 decimals 2 exponent 0 left-justified, / lv_ret1 left-justified.
