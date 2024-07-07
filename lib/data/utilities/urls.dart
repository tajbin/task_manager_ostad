class Urls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';

  static const registration = '$_baseUrl/registration';
  static const login = '$_baseUrl/login';
  static const createTask= '$_baseUrl/createTask';
  static const newTask = '$_baseUrl/listTaskByStatus/New';
  static const completedTask = '$_baseUrl/listTaskByStatus/Completed';
  static const canceledTask = '$_baseUrl/listTaskByStatus/Canceled';
  static const inProgressTask = '$_baseUrl/listTaskByStatus/InProgress';
  static const taskStatusCount = '$_baseUrl/taskStatusCount';
  static deleteTask(String id) => '$_baseUrl/deleteTask/$id';
  static updateTaskStatus(String id, String status) => "$_baseUrl/updateTaskStatus/$id/$status";
  static String updateProfile = '$_baseUrl/profileUpdate';
  static const recoverVerifyEmail = "$_baseUrl/RecoverVerifyEmail";
  static const recoverVerifyOTP = "$_baseUrl/RecoverVerifyOTP";
  static const recoverResetPass = "$_baseUrl/RecoverResetPass";

}