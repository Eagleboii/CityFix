import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_localizations.dart';
import 'signup_screen.dart';

import 'issue_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

 void _login(AuthProvider authProvider) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try{
         await authProvider.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
        _navigateToIssueScreen();
      }finally {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const IssueScreen()),
        );
      });
    }
  }

  void _loginAsGuest(AuthProvider authProvider) async {
    await authProvider.signInAsGuest();
    _navigateToIssueScreen();
  }

  void _loginWithGoogle(AuthProvider authProvider) async {
    await authProvider.signInWithGoogle();
    _navigateToIssueScreen();
  }

  void _loginWithApple(AuthProvider authProvider) async {
    await authProvider.signInWithApple();
    _navigateToIssueScreen();
  }

  void _navigateToSignup() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const SignupScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var fadeAnimation = Tween(
            begin: 0.0, 
            end: 1.0
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));
          
          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

    void _navigateToIssueScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const IssueScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final size = MediaQuery.of(context).size;
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                themeProvider.isDarkMode 
                    ? Icons.light_mode 
                    : Icons.dark_mode,
                color: isDark ? Colors.white : Colors.black,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // App Title and Description
                        SizedBox(height: size.height * 0.04),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                localizations.translate('login_title'),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${localizations.translate('login_subtitle')} ',
                                      style: TextStyle(
                                        color: const Color(0xFF8C61FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: size.height * 0.06),
                        
                        // Email field
                        TextFormField(
                          controller: _emailController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            labelText: localizations.translate('email'),
                            labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                            filled: true,
                            fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: const Color(0xFF8C61FF), width: 1),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            labelText: localizations.translate('password'),
                            labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                            filled: true,
                            fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: const Color(0xFF8C61FF), width: 1),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure ? Icons.visibility : Icons.visibility_off,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                          ),
                          obscureText: _isObscure,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Login Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : () => _login(authProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8C61FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(double.infinity, 54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  localizations.translate('sign_in'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        
                        SizedBox(height: 12),
                         ElevatedButton(

                            onPressed: () => _loginAsGuest(authProvider),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: isDark ? Colors.white : Colors.black,
                              backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              minimumSize: const Size(double.infinity, 54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Sign in as Guest', style: TextStyle(fontWeight: FontWeight.bold)),

                          ),

                          
                        
                        SizedBox(height: 24),
                        
                        // Additional login options separator
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Google login button
                       ElevatedButton(
                          onPressed: () => _loginWithGoogle(authProvider),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: isDark ? Colors.white : Colors.black,
                            backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(double.infinity, 54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Sign in with Google', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        
                        SizedBox(height: 12),
                        
                        // Apple login button
                        ElevatedButton(
                          onPressed: () => _loginWithApple(authProvider),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: isDark ? Colors.white : Colors.black,
                            backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(double.infinity, 54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Sign in with Apple', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Sign up text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: _navigateToSignup,
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF8C61FF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Terms and conditions
                        Text(
                          localizations.translate('terms_and_conditions'),
                          style: TextStyle(
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                localizations.translate('terms'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF8C61FF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              ' ${localizations.translate('and')} ',
                              style: TextStyle(
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                localizations.translate('privacy_policy'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF8C61FF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Add animated bubbles
                        _buildAnimatedBubbles(isDark),
                        
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedBubbles(bool isDark) {
    return Container(
      height: 100,
      child: Stack(
        children: List.generate(10, (index) {
          final size = 20.0 + (index * 5.0);
          final left = (index * 30.0) % (MediaQuery.of(context).size.width - size);
          final top = (index * 20.0) % 100;
          final opacity = 0.1 + (index % 3) * 0.1;
          final color = isDark ? Colors.white.withOpacity(opacity) : Colors.purple.withOpacity(opacity);
          
          return Positioned(
            left: left,
            top: top,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
} 