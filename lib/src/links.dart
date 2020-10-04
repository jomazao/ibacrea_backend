class Links {
  final String self;
  final String first;
  final String next;
  final String prev;
  final String last;

  Links({
    this.self,
    this.first,
    this.next,
    this.prev,
    this.last,
  });
  factory Links.fromMap(Map<String, dynamic> map) => Links(
      self: map['self'],
      first: map['first'],
      next: map['next'],
      prev: map['prev'],
      last: map['last']);
}
