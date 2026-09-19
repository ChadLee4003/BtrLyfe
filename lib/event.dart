class Event {
  final String title;
  final int minutes;
  final String category;

  Event({
    required this.title,
    required this.minutes,
    required this.category,
  });

  @override
  String toString() {
    return title;
  }
}