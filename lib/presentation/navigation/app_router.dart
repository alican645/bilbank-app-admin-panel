// Router'ın kullanılabilmesi için bir global navigator key tanımlanıyor
import 'package:bilbank_admin_panel/core/utils/vm_route.dart';
import 'package:bilbank_admin_panel/data/model/model/room_model.dart';
import 'package:bilbank_admin_panel/presentation/navigation/app_layout.dart';
import 'package:bilbank_admin_panel/presentation/navigation/app_page_keys.dart';
import 'package:bilbank_admin_panel/presentation/views/auth_module/login/login_view.dart';
import 'package:bilbank_admin_panel/presentation/views/auth_module/login/login_view_model.dart';
import 'package:bilbank_admin_panel/presentation/views/auth_module/register/register_view.dart';
import 'package:bilbank_admin_panel/presentation/views/auth_module/register/register_view_model.dart';
import 'package:bilbank_admin_panel/presentation/views/room_module/edit_room/edit_room_view.dart';
import 'package:bilbank_admin_panel/presentation/views/room_module/edit_room/edit_room_view_model.dart';
import 'package:bilbank_admin_panel/presentation/views/room_module/room_home/room_home.dart';
import 'package:bilbank_admin_panel/presentation/views/room_module/room_home/room_home_view_model.dart';
import 'package:bilbank_admin_panel/presentation/views/room_module/room_user/room_users_view.dart';
import 'package:bilbank_admin_panel/presentation/views/room_module/room_user/room_users_view_model.dart';
import 'package:bilbank_admin_panel/presentation/views/user_module/edit_user/edit_user_view.dart';
import 'package:bilbank_admin_panel/presentation/views/user_module/edit_user/edit_user_view_model.dart';
import 'package:bilbank_admin_panel/presentation/views/user_module/users_home/users_home_view.dart';
import 'package:bilbank_admin_panel/presentation/views/user_module/users_home/users_home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final routerKey = GlobalKey<NavigatorState>();

// GoRouter yapılandırması
GoRouter router() => GoRouter(
  // Uygulama ilk açıldığında yönlendirilecek olan başlangıç rotası
  initialLocation: AppPageKeys.login,

  // Navigator anahtarı (bazı işlemler için dışarıdan erişim gerekir)
  navigatorKey: routerKey,

  routes: [
    vmRoute(
      path: AppPageKeys.login,
      create: (_, _) => LoginViewModel(),
      child: (context, state) => LoginScreen(),
      routes: [
        vmRoute(
          path: AppPageKeys.register,
          create: (_, _) => RegisterViewModel(),
          child: (context, state) => RegisterScreen(),
        ),
      ],
    ),

    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          routes: [
            vmRoute(
              path: AppPageKeys.roomHome,
              create: (_, _) => RoomHomeViewModel(),
              child: (context, state) => RoomsHomeScreen(),
              routes: [
                vmRoute(
                  path: AppPageKeys.roomDetail,
                  create: (_, _) => EditRoomViewModel(),
                  child: (context, state) {
                    final room = state.extra as RoomModel;
                    return EditRoomScreen(room: room);
                  },
                  routes: [
                    vmRoute(
                      path: AppPageKeys.roomUsers,
                      create: (_, __) => RoomUsersViewModel(),
                      child: (context, state) {
                        final roomId = state.extra as String;
                        return RoomUsersScreen(roomId: roomId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            vmRoute(
              path: AppPageKeys.usersHome,
              create: (_, _) => UsersHomeViewModel(),
              child: (context, state) => UsersHomeScreen(),
              routes: [
                vmRoute(
                  path: AppPageKeys.userDetail,
                  create: (_, _) => EditUserViewModel(),
                  child: (context, state) => EditUserScreen(),
                ),
              ],
            ),
          ],
        ),
      ],

      // Tüm sekmeler için ortak layout (örn: BottomNavigationBar içeren widget)
      builder: (context, state, navigationShell) =>
          AppLayout(statefulNavigationShell: navigationShell),
    ),
  ],
);
