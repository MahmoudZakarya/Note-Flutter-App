import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/pages/home_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main(){
  runApp(ProviderScope(child: MyApp()));
  
  
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShadApp.material(
      debugShowCheckedModeBanner: false,
      title: "Notes",
      theme: ShadThemeData(
        colorScheme: ShadColorScheme(
          background: Colors.black, // Background color
          foreground: Colors.white, // Foreground text color
          card: Colors.black12, // Card background
          cardForeground: Colors.white, // Card text color
          popover: Colors.black12, // Popover background
          popoverForeground: Colors.white, // Popover text color
          primary: Colors.amberAccent, // Primary accent color
          primaryForeground: Colors.black, // Text on primary color
          secondary: Colors.grey, // Secondary accent color
          secondaryForeground: Colors.white, // Text on secondary color
          muted: Colors.grey[800]!, // Muted background color
          mutedForeground: Colors.grey[400]!, // Muted text color
          accent: Colors.amberAccent, // Accent color
          accentForeground: Colors.black, // Text on accent color
          destructive: Colors.redAccent, // Destructive action background
          destructiveForeground: Colors.white, // Text on destructive action
          border: Colors.grey[700]!, // Border color
          input: Colors.black26, // Input field background
          ring: Colors.amberAccent.withOpacity(0.5), // Focus ring color
          selection: Colors.amberAccent.withOpacity(0.3), ), brightness: Brightness.dark,
      ),
      home: HomePage()
    );
  }
}
