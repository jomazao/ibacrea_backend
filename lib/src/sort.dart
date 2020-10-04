class Sort {
  final String field;
  final SortType sortType;

  Sort(this.field, this.sortType);
}

enum SortType {
  asc,
  desc,
}
