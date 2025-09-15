import 'package:bilbank_admin_panel/presentation/components/main/custom_gradient_scaffold.dart';
import 'package:bilbank_admin_panel/presentation/components/main/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatelessWidget {

  // StatefulNavigationShell, her sekmenin state’ini korur ve yönlendirme yapmamıza izin verir
  final StatefulNavigationShell statefulNavigationShell;

  const AppLayout({super.key, required this.statefulNavigationShell});

  @override
  Widget build(BuildContext context) {
    return CustomGradientScaffold(

      // Aktif sekmenin gösterileceği ana içerik alanı
      body: statefulNavigationShell,

      bottomNavigationBar: CustomNavBar(
        // Şu anda seçili olan sekmenin index'i
        currentIndex: statefulNavigationShell.currentIndex,

        // Kullanıcı bir sekmeye tıkladığında çağrılır
        onTap: (index) {
          // Aynı sekmeye tekrar tıklandıysa initialLocation kullanılarak kök sayfaya dönülür
          statefulNavigationShell.goBranch(
            index,
            initialLocation: index == statefulNavigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

