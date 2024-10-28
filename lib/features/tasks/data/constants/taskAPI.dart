class TaskApiUrls {
  static const String baseTaskUrl = 'http://10.0.2.2:8000/';
  // static const String baseTaskUrl = 'http://10.101.0.231:8000/';
  // Routes
  static const String getRoutes = baseTaskUrl;
  static const String getTasks = "${baseTaskUrl}tasks/";
  static const String createtask = "${baseTaskUrl}tasks/create/";
  static String updateTasks(String pk) => "${baseTaskUrl}tasks/$pk/update/";
  static String deleteTasks(String pk) => "${baseTaskUrl}tasks/$pk/delete/";
  static String getTask(String pk) => "${baseTaskUrl}tasks/$pk/";
}
