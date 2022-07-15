class AppUrl {
  static const String liveBaseURL = "https://hivoyage.herokuapp.com/api/driver";
  static const String localBaseURL = "http://10.0.2.2:8000/api/driver";

  static const String baseURL = liveBaseURL;
  static const String login = baseURL + "/login";
  static const String forgotPassword = baseURL + "/forgot-password";
  static const String logout = baseURL + "/logout";
  static const String home = baseURL + "/home";
  static const String control = baseURL + "/control";
  static const String controlQr = baseURL + "/control/qr";
  static const String driverStat = baseURL + "/stat";
  static const String driverActivity = baseURL + "/activity";
  static const String driverPassedActivity = baseURL + "/activity/passed";
  static const String driverFutureActivity = baseURL + "/activity/future";
}
