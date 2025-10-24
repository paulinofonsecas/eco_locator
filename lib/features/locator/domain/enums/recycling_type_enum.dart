enum RecyclingType {
  metal('Metal'),
  vidro('Vidro'),
  vegetal('Vegetal'),
  unknown('Desconhecido');

  final String name;

  const RecyclingType(this.name);
}

RecyclingType? parseRecyclingType(String type) {
  return RecyclingType.values.where((e) => e.name == type).firstOrNull;
}