enum LocalStorageKeys {
  accessToken,
  refreshToken,
  firstPage,
  rememberMeEmail,
  rememberMePassword,
  rememberCheck,
  userId,
  userEmail,
  userName,
  userPhone,
  userTCNo,
  userProfileImageUrl,
  isDarkMode,
}


extension KeyName on LocalStorageKeys {
  String get key => 'local_storage_key.$name'; // tek bir isimlendirme standardı
}