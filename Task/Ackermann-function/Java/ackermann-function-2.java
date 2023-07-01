@FunctionalInterface
public interface FunctionalField<FIELD extends Enum<?>> {
  public Object untypedField(FIELD field);

  @SuppressWarnings("unchecked")
  public default <VALUE> VALUE field(FIELD field) {
    return (VALUE) untypedField(field);
  }
}
