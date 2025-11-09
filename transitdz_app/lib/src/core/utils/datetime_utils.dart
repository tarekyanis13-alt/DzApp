DateTime parseZonedDateTime(String value) {
  return DateTime.parse(value).toLocal();
}

String formatRelativeDuration(Duration duration) {
  if (duration.inMinutes < 60) {
    return '${duration.inMinutes} min';
  }
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  if (minutes == 0) {
    return '${hours}h';
  }
  return '${hours}h ${minutes}m';
}
