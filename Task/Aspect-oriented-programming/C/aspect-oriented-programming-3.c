struct object {
  struct object_operations *ops;
  int member;
};

struct object_operations {
  void (*frob_member)(struct object *obj, int how);
};
