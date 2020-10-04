class Field {
  final String field;
  final QueryType queryType;
  final dynamic value;

  Field(
    this.field,
    this.queryType,
    this.value,
  );
  factory Field.eq(
    String field,
    String value,
  ) =>
      Field(
        field,
        QueryType.eq,
        value,
      );
}

enum QueryType {
  eq,
  gt,
  ge,
  lt,
  le,
  ne,
  sw,
  ew,
  has,
  notHas,
  notSw,
  notEw,
}
