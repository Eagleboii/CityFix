import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flag/flag.dart';
import 'dart:ui';
import '../providers/theme_provider.dart';
import '../utils/app_localizations.dart';
import 'issue_screen.dart';

class CountryCode {
  final String name;
  final String dialCode;
  final FlagsCode flagCode; // Using FlagsCode enum

  CountryCode({required this.name, required this.dialCode, required this.flagCode});
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // List of country codes - using FlagsCode enum
  final List<CountryCode> _countryCodes = [
    CountryCode(name: 'Afghanistan', dialCode: '+93', flagCode: FlagsCode.AF),
    CountryCode(name: 'Albania', dialCode: '+355', flagCode: FlagsCode.AL),
    CountryCode(name: 'Algeria', dialCode: '+213', flagCode: FlagsCode.DZ),
    CountryCode(name: 'Andorra', dialCode: '+376', flagCode: FlagsCode.AD),
    CountryCode(name: 'Angola', dialCode: '+244', flagCode: FlagsCode.AO),
    CountryCode(name: 'Argentina', dialCode: '+54', flagCode: FlagsCode.AR),
    CountryCode(name: 'Armenia', dialCode: '+374', flagCode: FlagsCode.AM),
    CountryCode(name: 'Australia', dialCode: '+61', flagCode: FlagsCode.AU),
    CountryCode(name: 'Austria', dialCode: '+43', flagCode: FlagsCode.AT),
    CountryCode(name: 'Azerbaijan', dialCode: '+994', flagCode: FlagsCode.AZ),
    CountryCode(name: 'Bahamas', dialCode: '+1', flagCode: FlagsCode.BS),
    CountryCode(name: 'Bahrain', dialCode: '+973', flagCode: FlagsCode.BH),
    CountryCode(name: 'Bangladesh', dialCode: '+880', flagCode: FlagsCode.BD),
    CountryCode(name: 'Belgium', dialCode: '+32', flagCode: FlagsCode.BE),
    CountryCode(name: 'Brazil', dialCode: '+55', flagCode: FlagsCode.BR),
    CountryCode(name: 'Canada', dialCode: '+1', flagCode: FlagsCode.CA),
    CountryCode(name: 'China', dialCode: '+86', flagCode: FlagsCode.CN),
    CountryCode(name: 'Colombia', dialCode: '+57', flagCode: FlagsCode.CO),
    CountryCode(name: 'Egypt', dialCode: '+20', flagCode: FlagsCode.EG),
    CountryCode(name: 'France', dialCode: '+33', flagCode: FlagsCode.FR),
    CountryCode(name: 'Germany', dialCode: '+49', flagCode: FlagsCode.DE),
    CountryCode(name: 'India', dialCode: '+91', flagCode: FlagsCode.IN),
    CountryCode(name: 'Indonesia', dialCode: '+62', flagCode: FlagsCode.ID),
    CountryCode(name: 'Iran', dialCode: '+98', flagCode: FlagsCode.IR),
    CountryCode(name: 'Iraq', dialCode: '+964', flagCode: FlagsCode.IQ),
    CountryCode(name: 'Italy', dialCode: '+39', flagCode: FlagsCode.IT),
    CountryCode(name: 'Japan', dialCode: '+81', flagCode: FlagsCode.JP),
    CountryCode(name: 'Jordan', dialCode: '+962', flagCode: FlagsCode.JO),
    CountryCode(name: 'Kenya', dialCode: '+254', flagCode: FlagsCode.KE),
    CountryCode(name: 'Malaysia', dialCode: '+60', flagCode: FlagsCode.MY),
    CountryCode(name: 'Mexico', dialCode: '+52', flagCode: FlagsCode.MX),
    CountryCode(name: 'Morocco', dialCode: '+212', flagCode: FlagsCode.MA),
    CountryCode(name: 'Netherlands', dialCode: '+31', flagCode: FlagsCode.NL),
    CountryCode(name: 'Nigeria', dialCode: '+234', flagCode: FlagsCode.NG),
    CountryCode(name: 'Norway', dialCode: '+47', flagCode: FlagsCode.NO),
    CountryCode(name: 'Pakistan', dialCode: '+92', flagCode: FlagsCode.PK),
    CountryCode(name: 'Philippines', dialCode: '+63', flagCode: FlagsCode.PH),
    CountryCode(name: 'Poland', dialCode: '+48', flagCode: FlagsCode.PL),
    CountryCode(name: 'Portugal', dialCode: '+351', flagCode: FlagsCode.PT),
    CountryCode(name: 'Qatar', dialCode: '+974', flagCode: FlagsCode.QA),
    CountryCode(name: 'Russia', dialCode: '+7', flagCode: FlagsCode.RU),
    CountryCode(name: 'Saudi Arabia', dialCode: '+966', flagCode: FlagsCode.SA),
    CountryCode(name: 'Singapore', dialCode: '+65', flagCode: FlagsCode.SG),
    CountryCode(name: 'South Africa', dialCode: '+27', flagCode: FlagsCode.ZA),
    CountryCode(name: 'South Korea', dialCode: '+82', flagCode: FlagsCode.KR),
    CountryCode(name: 'Spain', dialCode: '+34', flagCode: FlagsCode.ES),
    CountryCode(name: 'Sweden', dialCode: '+46', flagCode: FlagsCode.SE),
    CountryCode(name: 'Switzerland', dialCode: '+41', flagCode: FlagsCode.CH),
    CountryCode(name: 'Thailand', dialCode: '+66', flagCode: FlagsCode.TH),
    CountryCode(name: 'Turkey', dialCode: '+90', flagCode: FlagsCode.TR),
    CountryCode(name: 'Ukraine', dialCode: '+380', flagCode: FlagsCode.UA),
    CountryCode(name: 'United Arab Emirates', dialCode: '+971', flagCode: FlagsCode.AE),
    CountryCode(name: 'United Kingdom', dialCode: '+44', flagCode: FlagsCode.GB),
    CountryCode(name: 'United States', dialCode: '+1', flagCode: FlagsCode.US),
    CountryCode(name: 'Vietnam', dialCode: '+84', flagCode: FlagsCode.VN),
  ];
  
  // Default selected country code
  CountryCode _selectedCountryCode = CountryCode(name: 'Morocco', dialCode: '+212', flagCode: FlagsCode.MA);

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
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Show country code picker
  void _showCountryCodePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final isDark = themeProvider.isDarkMode;
        
        return Container(
          height: 400,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade900 : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    Text(
                      'Select Country',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _countryCodes.length,
                  itemBuilder: (context, index) {
                    return _buildCountryListTile(_countryCodes[index], isDark);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // In a real app, you would register with a backend service
      // Simulate network delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const IssueScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Registration Title
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        localizations.translate('register_title'),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: localizations.translate('register_subtitle'),
                              style: TextStyle(
                                color: const Color(0xFF8C61FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Full Name Field
                    TextFormField(
                      controller: _fullNameController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: localizations.translate('full_name'),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Email Field
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
                    
                    const SizedBox(height: 16),
                    
                    // Phone Number Field with Country Code
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Country code dropdown
                        Container(
                          width: 110,
                          child: _buildCountryCodeDropdown(isDark),
                        ),
                        SizedBox(width: 12),
                        // Phone number field
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            decoration: InputDecoration(
                              labelText: localizations.translate('phone_number'),
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
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Password Field
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
                            _isObscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscurePassword = !_isObscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _isObscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Confirm Password Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: localizations.translate('confirm_password'),
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
                            _isObscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscureConfirmPassword = !_isObscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _isObscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Sign Up Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signup,
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
                              localizations.translate('sign_up'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Login Link
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          localizations.translate('already_have_account'),
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF8C61FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountryCodeDropdown(bool isDark) {
    return InkWell(
      onTap: _showCountryCodePicker,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 18,
              child: Flag.fromCode(
                _selectedCountryCode.flagCode,
                fit: BoxFit.cover,
                borderRadius: 2,
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                _selectedCountryCode.dialCode,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: isDark ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryListTile(CountryCode countryCode, bool isDark) {
    return ListTile(
      leading: SizedBox(
        width: 32,
        height: 20,
        child: Flag.fromCode(
          countryCode.flagCode,
          fit: BoxFit.cover,
          borderRadius: 2,
        ),
      ),
      title: Text(
        countryCode.name, 
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
      subtitle: Text(
        countryCode.dialCode, 
        style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
      ),
      onTap: () {
        setState(() {
          _selectedCountryCode = countryCode;
        });
        Navigator.pop(context);
      },
    );
  }
} 