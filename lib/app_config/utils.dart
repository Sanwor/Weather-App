class AppUtils {
  getDayOrNightFromOffset(int offsetInSeconds) { // OffsetInSeconds accepts timezone code of a certain city
    // Get current UTC time
    final nowUtc = DateTime.now().toUtc();

    // Add the offset to get local time of the target location
    final localTime = nowUtc.add(Duration(seconds: offsetInSeconds));

    // Determine if it's daytime (6 AM to before 6 PM)
    final isDay = localTime.hour >= 6 && localTime.hour < 18;

    return isDay;
  }
}

