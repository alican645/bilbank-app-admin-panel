class AppPageKeys {
  AppPageKeys._();


  ///[ROOM_MODULE]

  static const roomHome = '/room_home';

  static const roomDetail = 'room_detail';
  static const roomDetailPath = '$roomHome/$roomDetail';
  
  static const roomUsers='room_users';
  static const roomUsersPath = '$roomHome/$roomDetail/$roomUsers';

  ///[USER_MODULE]
  static const usersHome = '/user_home';
  static const userDetail = 'user_detail';
  static const userDetailPath = '$usersHome/$userDetail';






  ///[AUTH_MODULE]
  static const login = '/login';
  static const register = 'registert';
  static const registerPath = '$login/$register';
  








  

}
