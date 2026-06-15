
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mytherapio_admin_app/screens/auth/document_upload_screen.dart';
import 'package:mytherapio_admin_app/screens/auth/login_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const Mytherapioadminapp());
}

class Mytherapioadminapp extends StatelessWidget {
  const Mytherapioadminapp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Kernalscape',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: false,
            fontFamily: 'SFProText',
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0066CC),
              secondary: Color(0xFFE8610A),
              surface: Colors.white,
              background: Color(0xFFF4F4F9),
              error: Color(0xFFE53935),
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: Color(0xFF1A1A2E),
              onBackground: Color(0xFF1A1A2E),
              onError: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFFF4F4F9),

            // ── AppBar ────────────────────────────────────────────────────────
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1A2A4A),
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                fontFamily: 'SFProText',
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),

            // ── Buttons ───────────────────────────────────────────────────────
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC),
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                textStyle: const TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0066CC),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF0066CC)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                textStyle: const TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0066CC),
                textStyle: const TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),

            // ── Input fields ──────────────────────────────────────────────────
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCDD)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCDD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide:
                    const BorderSide(color: Color(0xFF0066CC), width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFE53935)),
              ),
              hintStyle: const TextStyle(
                color: Color(0xFF8A8AA8),
                fontSize: 13,
                fontFamily: 'SFProText',
              ),
              labelStyle: const TextStyle(
                color: Color(0xFF4A4A68),
                fontSize: 13,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w500,
              ),
            ),

            // ── Cards ─────────────────────────────────────────────────────────
            cardTheme: CardTheme(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(color: Color(0xFFE0E0EE)),
              ),
              margin: EdgeInsets.zero,
            ),

            // ── Divider ───────────────────────────────────────────────────────
            dividerTheme: const DividerThemeData(
              color: Color(0xFFE0E0EE),
              thickness: 1,
              space: 1,
            ),

            // ── FAB ───────────────────────────────────────────────────────────
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFF0066CC),
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),

            // ── Bottom Navigation ─────────────────────────────────────────────
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Color(0xFF0066CC),
              unselectedItemColor: Color(0xFF8A8AA8),
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: TextStyle(
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'SFProText',
                fontSize: 11,
              ),
            ),

            // ── Tab Bar ───────────────────────────────────────────────────────
            tabBarTheme: const TabBarTheme(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: TextStyle(
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'SFProText',
                fontSize: 13,
              ),
            ),

            // ── Dialog ────────────────────────────────────────────────────────
            dialogTheme: DialogTheme(
              backgroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              titleTextStyle: const TextStyle(
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF1A1A2E),
              ),
              contentTextStyle: const TextStyle(
                fontFamily: 'SFProText',
                fontSize: 14,
                color: Color(0xFF4A4A68),
              ),
            ),

            // ── Chip ──────────────────────────────────────────────────────────
            chipTheme: ChipThemeData(
              backgroundColor: const Color(0xFFF4F4F9),
              selectedColor: const Color(0xFFE8F3FF),
              labelStyle: const TextStyle(
                fontFamily: 'SFProText',
                fontSize: 12,
                color: Color(0xFF4A4A68),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              side: const BorderSide(color: Color(0xFFE0E0EE)),
            ),

            // ── ListTile ──────────────────────────────────────────────────────
            listTileTheme: const ListTileThemeData(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              dense: true,
            ),

            // ── Text ──────────────────────────────────────────────────────────
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Color(0xFF1A1A2E)),
              headlineMedium: TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xFF1A1A2E)),
              titleLarge: TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: Color(0xFF1A1A2E)),
              titleMedium: TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFF1A1A2E)),
              titleSmall: TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF1A1A2E)),
              bodyLarge: TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF1A1A2E)),
              bodyMedium: TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: Color(0xFF4A4A68)),
              bodySmall: TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: Color(0xFF8A8AA8)),
              labelLarge: TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF1A1A2E)),
              labelMedium: TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xFF4A4A68)),
              labelSmall: TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  letterSpacing: 0.8,
                  color: Color(0xFF8A8AA8)),
            ),
          ),
          home: const LoginScreen(),
          // home: const DocumentUploadScreen(),
        );
      },
    );
  }
}

