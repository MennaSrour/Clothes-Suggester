/// Model class representing the reward system
/// Tracks stars earned and plant growth progress
class RewardModel {
  final int stars; // Total stars earned
  final int plantGrowth; // Growth level: 0 = seed, 1 = plant, 2 = tree

  RewardModel({
    required this.stars,
    required this.plantGrowth,
  });

  /// Create a RewardModel from JSON
  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      stars: json['stars'] as int,
      plantGrowth: json['plantGrowth'] as int,
    );
  }

  /// Convert RewardModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'stars': stars,
      'plantGrowth': plantGrowth,
    };
  }

  /// Create a copy of the RewardModel with updated values
  RewardModel copyWith({
    int? stars,
    int? plantGrowth,
  }) {
    return RewardModel(
      stars: stars ?? this.stars,
      plantGrowth: plantGrowth ?? this.plantGrowth,
    );
  }

  /// Get the plant stage name
  String get plantStageName {
    switch (plantGrowth) {
      case 0:
        return 'Seed';
      case 1:
        return 'Plant';
      case 2:
        return 'Tree';
      default:
        return 'Unknown';
    }
  }

  /// Get the plant emoji representation
  String get plantEmoji {
    switch (plantGrowth) {
      case 0:
        return '🌱'; // Seed
      case 1:
        return '🪴'; // Plant
      case 2:
        return '🌳'; // Tree
      default:
        return '🌱';
    }
  }

  @override
  String toString() {
    return 'RewardModel(stars: $stars, plantGrowth: $plantGrowth, stage: $plantStageName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RewardModel &&
        other.stars == stars &&
        other.plantGrowth == plantGrowth;
  }

  @override
  int get hashCode {
    return stars.hashCode ^ plantGrowth.hashCode;
  }
}
