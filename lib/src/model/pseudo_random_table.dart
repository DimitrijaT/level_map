class PseudoRandomTable {
  final List<double> pseudoRandomDoubles;
  final List<bool> pseudoRandomBooleans;

  int _doubleIndex = 0;
  int _booleanIndex = 0;

  PseudoRandomTable._({
    required this.pseudoRandomDoubles,
    required this.pseudoRandomBooleans,
  });

  static int _lcg(int seed) {
    const int a = 1664525;
    const int c = 1013904223;
    const int m = 4294967296; // 2^32
    return (a * seed + c) % m;
  }

  static double _offsetDouble(double value, int seed) {
    int randomInt = _lcg(seed);
    double offset = (randomInt / 4294967296.0) - 0.5;
    return (value + offset).clamp(0.0, 1.0);
  }

  static bool _offsetBoolean(bool value, int seed) {
    int randomInt = _lcg(seed);
    return (randomInt % 2 == 0) ? value : !value;
  }

  factory PseudoRandomTable.hardcoded(int staticSeed) {
    List<double> originalDoubles = [
      0.23,
      0.47,
      0.12,
      0.89,
      0.65,
      0.33,
      0.92,
      0.01,
      0.76,
      0.42,
      0.34,
      0.56,
      0.19,
      0.87,
      0.29,
      0.48,
      0.15,
      0.99,
      0.78,
      0.24,
      0.67,
      0.88,
      0.11,
      0.44,
      0.82,
      0.09,
      0.91,
      0.30,
      0.64,
      0.50,
      0.36,
      0.28,
      0.18,
      0.73,
      0.60,
      0.85,
      0.49,
      0.77,
      0.54,
      0.21,
    ];

    List<bool> originalBooleans = [
      true,
      false,
      true,
      false,
      true,
      false,
      true,
      true,
      false,
      false,
      true,
      true,
      false,
      true,
      false,
      true,
      false,
      false,
      true,
      true,
      false,
      true,
      true,
      false,
      false,
      true,
      false,
      true,
      true,
      true,
      false,
      true,
      false,
      false,
      true,
      true,
      true,
      false,
      false,
      true,
    ];

    if (staticSeed != 0) {
      List<double> offsetDoubles = originalDoubles
          .asMap()
          .entries
          .map((entry) => _offsetDouble(entry.value, staticSeed + entry.key))
          .toList();

      List<bool> offsetBooleans = originalBooleans
          .asMap()
          .entries
          .map((entry) => _offsetBoolean(entry.value, staticSeed + entry.key))
          .toList();

      return PseudoRandomTable._(
        pseudoRandomDoubles: offsetDoubles,
        pseudoRandomBooleans: offsetBooleans,
      );
    } else {
      return PseudoRandomTable._(
        pseudoRandomDoubles: originalDoubles,
        pseudoRandomBooleans: originalBooleans,
      );
    }
  }

  double nextDouble() {
    double value = pseudoRandomDoubles[_doubleIndex];
    _doubleIndex = (_doubleIndex + 1) % pseudoRandomDoubles.length;
    return value;
  }

  bool nextBool() {
    bool value = pseudoRandomBooleans[_booleanIndex];
    _booleanIndex = (_booleanIndex + 1) % pseudoRandomBooleans.length;
    return value;
  }

  void reset() {
    _doubleIndex = 0;
    _booleanIndex = 0;
  }
}
