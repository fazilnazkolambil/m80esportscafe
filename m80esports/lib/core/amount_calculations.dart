double calculateAmount(int minutesPlayed, String deviceType) {
  int fullHours = minutesPlayed ~/ 60;
  int remainingMinutes = minutesPlayed % 60;

  double amount = 0;

  if (deviceType.contains('PC')) {
    if (minutesPlayed <= 60) {
      amount = (minutesPlayed / 60) * 120;
    } else {
      switch (fullHours) {
        case 1:
          amount = 120 + (remainingMinutes / 60) * (200 - 120);
          break;
        case 2:
          amount = 200 + (remainingMinutes / 60) * (270 - 200);
          break;
        case 3:
          amount = 270 + (remainingMinutes / 60) * (320 - 270);
          break;
        case 4:
          amount = 320 + (remainingMinutes / 60) * (350 - 320);
          break;
        default:
          amount = 350 + ((minutesPlayed - 300) / 60) * 50;
          break;
      }
    }
    return amount;
  } else if (deviceType.contains('TV')) {
    if (minutesPlayed <= 60) {
      amount = (minutesPlayed / 60) * 180;
    } else {
      switch (fullHours) {
        case 1:
          amount = 180 + (remainingMinutes / 60) * (320 - 180);
          break;
        case 2:
          amount = 320 + (remainingMinutes / 60) * (420 - 320);
          break;
        default:
          amount = 420 + ((minutesPlayed - 180) / 60) * 90;
          break;
      }
    }
    return amount;
  } else if (deviceType.contains('PROJECTOR')) {
    if (minutesPlayed <= 60) {
      amount = (minutesPlayed / 60) * 200;
    } else {
      switch (fullHours) {
        case 1:
          amount = 200 + (remainingMinutes / 60) * (350 - 200);
          break;
        case 2:
          amount = 350 + (remainingMinutes / 60) * (500 - 350);
          break;
        default:
          amount = 500 + ((minutesPlayed - 180) / 60) * 100;
          break;
      }
    }
    return amount;
  } else if (deviceType == 'RACING SIMULATOR') {
    if (minutesPlayed <= 60) {
      amount = (minutesPlayed / 60) * 180;
    } else {
      switch (fullHours) {
        case 1:
          amount = 180 + (remainingMinutes / 60) * (330 - 180);
          break;
        case 2:
          amount = 330 + (remainingMinutes / 60) * (430 - 330);
          break;
        default:
          amount = 430 + ((minutesPlayed - 180) / 60) * 90;
          break;
      }
    }
    return amount;
  } else if (deviceType == 'NINTENDO') {
    if (minutesPlayed <= 60) {
      amount = (minutesPlayed / 60) * 200;
    } else {
      amount = 200 + ((minutesPlayed - 60) / 60) * 150;
    }
    return amount;
  } else if (deviceType.contains('META')) {
    if (minutesPlayed <= 60) {
      amount = (minutesPlayed / 60) * 180;
    } else {
      amount = 180 + ((minutesPlayed - 60) / 60) * 100;
    }
    return amount;
  } else {
    return 0;
  }
}
