import 'dart:ui';

class ColorConst {
  static const secondaryColor = Color(0xff000000);
  static const backgroundColor =
      Color(0xff1B0038); // Deep Plum for the background
  static const textColor =
      Color(0xffF8F8FF); // Ghost White for clean and bright text
  static const buttons =
      // Color(0xffFF00FF); // Magenta for buttons to create a pop
      Color.fromARGB(255, 77, 0, 165); // Magenta for buttons to create a pop
  static const errorAlert =
      Color.fromARGB(255, 255, 0, 0); // Bright Orange Red for error alerts
  static const successAlert =
      Color.fromARGB(255, 0, 255, 128); // Spring Green for success alerts
  static const testColor =
      Color(0xff8A2BE2); // Blue Violet for additional decorative elements
}

class ImageConst {
  static const logo = 'assets/images/M80_logo.png';
}

class IconConst {
  static const googleLogo = 'assets/icons/google.svg';
  static const facebookLogo = 'assets/icons/facebook.svg';
  static const appleLogo = 'assets/icons/apple.svg';
}

class Gifs {
  static const loadingGif = 'assets/gifs/Loading.json';
}
