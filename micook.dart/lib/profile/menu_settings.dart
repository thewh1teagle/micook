class MenuSettings {
  bool saveRecipe;
  bool confirmStart;
  bool menuUnknown3;
  bool menuUnknown4;
  bool menuUnknown5;
  bool menuUnknown6;
  MenuSettings(
      {this.saveRecipe = false,
      this.confirmStart = false,
      this.menuUnknown3 = false,
      this.menuUnknown4 = false,
      this.menuUnknown5 = false,
      this.menuUnknown6 = false});

  int toInt() {
    int bits = (saveRecipe ? 1 : 0) << 7;
    bits |= (confirmStart ? 1 : 0) << 6;
    bits |= (menuUnknown3 ? 1 : 0) << 5;
    bits |= (menuUnknown4 ? 1 : 0) << 4;
    bits |= (menuUnknown5 ? 1 : 0) << 3;
    bits |= (menuUnknown6 ? 1 : 0) << 2;
    return bits;
  }
}
