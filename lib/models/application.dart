class Application {
  final String companyName;
  final String position;
  final String location;
  final String dateApplied;

  Application({
    required this.companyName,
    required this.position,
    required this.location,
    required this.dateApplied,
  });

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'position': position,
        'location': location,
        'dateApplied': dateApplied,
      };

  factory Application.fromJson(Map<String, dynamic> json) => Application(
        companyName: json['companyName'],
        position: json['position'],
        location: json['location'],
        dateApplied: json['dateApplied'],
      );
}
