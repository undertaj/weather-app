

class Location {
  Location({
    required this.name,
    // required this.localNames,
    required this.lat,
    required this.lon,
    required this.country,
    required this.state,
  });

  final String? name;
  // final Map<String, String> localNames;
  final double? lat;
  final double? lon;
  final String? country;
  final String? state;

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      name: json["name"],
      // localNames: Map.from(json["local_names"]).map((k, v) => MapEntry<String, String>(k, v)),
      lat: json["lat"],
      lon: json["lon"],
      country: json["country"],
      state: json["state"],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    // "local_names": Map.from(localNames).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "lat": lat,
    "lon": lon,
    "country": country,
    "state": state,
  };

}
