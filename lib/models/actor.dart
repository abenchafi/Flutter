class Actor {
  final int id;
  final String name;
  final String profilePath;

  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      profilePath: json['profile_path'] ?? '',
    );
  }
}