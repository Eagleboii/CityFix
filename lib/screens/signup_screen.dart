import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'issue_screen.dart';

class CountryCode {
  final String name;
  final String dialCode;
  final String flag;

  CountryCode({required this.name, required this.dialCode, required this.flag});
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

  // List of country codes
  final List<CountryCode> _countryCodes = [
    CountryCode(name: 'Afghanistan', dialCode: '+93', flag: '🇦🇫'),
    CountryCode(name: 'Albania', dialCode: '+355', flag: '🇦🇱'),
    CountryCode(name: 'Algeria', dialCode: '+213', flag: '🇩🇿'),
    CountryCode(name: 'Andorra', dialCode: '+376', flag: '🇦🇩'),
    CountryCode(name: 'Angola', dialCode: '+244', flag: '🇦🇴'),
    CountryCode(name: 'Argentina', dialCode: '+54', flag: '🇦🇷'),
    CountryCode(name: 'Armenia', dialCode: '+374', flag: '🇦🇲'),
    CountryCode(name: 'Australia', dialCode: '+61', flag: '🇦🇺'),
    CountryCode(name: 'Austria', dialCode: '+43', flag: '🇦🇹'),
    CountryCode(name: 'Azerbaijan', dialCode: '+994', flag: '🇦🇿'),
    CountryCode(name: 'Bahamas', dialCode: '+1', flag: '🇧🇸'),
    CountryCode(name: 'Bahrain', dialCode: '+973', flag: '🇧🇭'),
    CountryCode(name: 'Bangladesh', dialCode: '+880', flag: '🇧🇩'),
    CountryCode(name: 'Barbados', dialCode: '+1', flag: '🇧🇧'),
    CountryCode(name: 'Belarus', dialCode: '+375', flag: '🇧🇾'),
    CountryCode(name: 'Belgium', dialCode: '+32', flag: '🇧🇪'),
    CountryCode(name: 'Belize', dialCode: '+501', flag: '🇧🇿'),
    CountryCode(name: 'Benin', dialCode: '+229', flag: '🇧🇯'),
    CountryCode(name: 'Bhutan', dialCode: '+975', flag: '🇧🇹'),
    CountryCode(name: 'Bolivia', dialCode: '+591', flag: '🇧🇴'),
    CountryCode(name: 'Bosnia', dialCode: '+387', flag: '🇧🇦'),
    CountryCode(name: 'Botswana', dialCode: '+267', flag: '🇧🇼'),
    CountryCode(name: 'Brazil', dialCode: '+55', flag: '🇧🇷'),
    CountryCode(name: 'Brunei', dialCode: '+673', flag: '🇧🇳'),
    CountryCode(name: 'Bulgaria', dialCode: '+359', flag: '🇧🇬'),
    CountryCode(name: 'Burkina Faso', dialCode: '+226', flag: '🇧🇫'),
    CountryCode(name: 'Burundi', dialCode: '+257', flag: '🇧🇮'),
    CountryCode(name: 'Cambodia', dialCode: '+855', flag: '🇰🇭'),
    CountryCode(name: 'Cameroon', dialCode: '+237', flag: '🇨🇲'),
    CountryCode(name: 'Canada', dialCode: '+1', flag: '🇨🇦'),
    CountryCode(name: 'Cape Verde', dialCode: '+238', flag: '🇨🇻'),
    CountryCode(name: 'Central African Republic', dialCode: '+236', flag: '🇨🇫'),
    CountryCode(name: 'Chad', dialCode: '+235', flag: '🇹🇩'),
    CountryCode(name: 'Chile', dialCode: '+56', flag: '🇨🇱'),
    CountryCode(name: 'China', dialCode: '+86', flag: '🇨🇳'),
    CountryCode(name: 'Colombia', dialCode: '+57', flag: '🇨🇴'),
    CountryCode(name: 'Comoros', dialCode: '+269', flag: '🇰🇲'),
    CountryCode(name: 'Costa Rica', dialCode: '+506', flag: '🇨🇷'),
    CountryCode(name: 'Croatia', dialCode: '+385', flag: '🇭🇷'),
    CountryCode(name: 'Cuba', dialCode: '+53', flag: '🇨🇺'),
    CountryCode(name: 'Cyprus', dialCode: '+357', flag: '🇨🇾'),
    CountryCode(name: 'Czech Republic', dialCode: '+420', flag: '🇨🇿'),
    CountryCode(name: 'Denmark', dialCode: '+45', flag: '🇩🇰'),
    CountryCode(name: 'Djibouti', dialCode: '+253', flag: '🇩🇯'),
    CountryCode(name: 'Dominican Republic', dialCode: '+1', flag: '🇩🇴'),
    CountryCode(name: 'Ecuador', dialCode: '+593', flag: '🇪🇨'),
    CountryCode(name: 'Egypt', dialCode: '+20', flag: '🇪🇬'),
    CountryCode(name: 'El Salvador', dialCode: '+503', flag: '🇸🇻'),
    CountryCode(name: 'Equatorial Guinea', dialCode: '+240', flag: '🇬🇶'),
    CountryCode(name: 'Eritrea', dialCode: '+291', flag: '🇪🇷'),
    CountryCode(name: 'Estonia', dialCode: '+372', flag: '🇪🇪'),
    CountryCode(name: 'Ethiopia', dialCode: '+251', flag: '🇪🇹'),
    CountryCode(name: 'Fiji', dialCode: '+679', flag: '🇫🇯'),
    CountryCode(name: 'Finland', dialCode: '+358', flag: '🇫🇮'),
    CountryCode(name: 'France', dialCode: '+33', flag: '🇫🇷'),
    CountryCode(name: 'Gabon', dialCode: '+241', flag: '🇬🇦'),
    CountryCode(name: 'Gambia', dialCode: '+220', flag: '🇬🇲'),
    CountryCode(name: 'Georgia', dialCode: '+995', flag: '🇬🇪'),
    CountryCode(name: 'Germany', dialCode: '+49', flag: '🇩🇪'),
    CountryCode(name: 'Ghana', dialCode: '+233', flag: '🇬🇭'),
    CountryCode(name: 'Greece', dialCode: '+30', flag: '🇬🇷'),
    CountryCode(name: 'Grenada', dialCode: '+1', flag: '🇬🇩'),
    CountryCode(name: 'Guatemala', dialCode: '+502', flag: '🇬🇹'),
    CountryCode(name: 'Guinea', dialCode: '+224', flag: '🇬🇳'),
    CountryCode(name: 'Guinea-Bissau', dialCode: '+245', flag: '🇬🇼'),
    CountryCode(name: 'Guyana', dialCode: '+592', flag: '🇬🇾'),
    CountryCode(name: 'Haiti', dialCode: '+509', flag: '🇭🇹'),
    CountryCode(name: 'Honduras', dialCode: '+504', flag: '🇭🇳'),
    CountryCode(name: 'Hungary', dialCode: '+36', flag: '🇭🇺'),
    CountryCode(name: 'Iceland', dialCode: '+354', flag: '🇮🇸'),
    CountryCode(name: 'India', dialCode: '+91', flag: '🇮🇳'),
    CountryCode(name: 'Indonesia', dialCode: '+62', flag: '🇮🇩'),
    CountryCode(name: 'Iran', dialCode: '+98', flag: '🇮🇷'),
    CountryCode(name: 'Iraq', dialCode: '+964', flag: '🇮🇶'),
    CountryCode(name: 'Ireland', dialCode: '+353', flag: '🇮🇪'),
    CountryCode(name: 'Israel', dialCode: '+972', flag: '🇮🇱'),
    CountryCode(name: 'Italy', dialCode: '+39', flag: '🇮🇹'),
    CountryCode(name: 'Jamaica', dialCode: '+1', flag: '🇯🇲'),
    CountryCode(name: 'Japan', dialCode: '+81', flag: '🇯🇵'),
    CountryCode(name: 'Jordan', dialCode: '+962', flag: '🇯🇴'),
    CountryCode(name: 'Kazakhstan', dialCode: '+7', flag: '🇰🇿'),
    CountryCode(name: 'Kenya', dialCode: '+254', flag: '🇰🇪'),
    CountryCode(name: 'Kuwait', dialCode: '+965', flag: '🇰🇼'),
    CountryCode(name: 'Kyrgyzstan', dialCode: '+996', flag: '🇰🇬'),
    CountryCode(name: 'Laos', dialCode: '+856', flag: '🇱🇦'),
    CountryCode(name: 'Latvia', dialCode: '+371', flag: '🇱🇻'),
    CountryCode(name: 'Lebanon', dialCode: '+961', flag: '🇱🇧'),
    CountryCode(name: 'Lesotho', dialCode: '+266', flag: '🇱🇸'),
    CountryCode(name: 'Liberia', dialCode: '+231', flag: '🇱🇷'),
    CountryCode(name: 'Libya', dialCode: '+218', flag: '🇱🇾'),
    CountryCode(name: 'Liechtenstein', dialCode: '+423', flag: '🇱🇮'),
    CountryCode(name: 'Lithuania', dialCode: '+370', flag: '🇱🇹'),
    CountryCode(name: 'Luxembourg', dialCode: '+352', flag: '🇱🇺'),
    CountryCode(name: 'Madagascar', dialCode: '+261', flag: '🇲🇬'),
    CountryCode(name: 'Malawi', dialCode: '+265', flag: '🇲🇼'),
    CountryCode(name: 'Malaysia', dialCode: '+60', flag: '🇲🇾'),
    CountryCode(name: 'Maldives', dialCode: '+960', flag: '🇲🇻'),
    CountryCode(name: 'Mali', dialCode: '+223', flag: '🇲🇱'),
    CountryCode(name: 'Malta', dialCode: '+356', flag: '🇲🇹'),
    CountryCode(name: 'Mauritania', dialCode: '+222', flag: '🇲🇷'),
    CountryCode(name: 'Mauritius', dialCode: '+230', flag: '🇲🇺'),
    CountryCode(name: 'Mexico', dialCode: '+52', flag: '🇲🇽'),
    CountryCode(name: 'Moldova', dialCode: '+373', flag: '🇲🇩'),
    CountryCode(name: 'Monaco', dialCode: '+377', flag: '🇲🇨'),
    CountryCode(name: 'Mongolia', dialCode: '+976', flag: '🇲🇳'),
    CountryCode(name: 'Montenegro', dialCode: '+382', flag: '🇲🇪'),
    CountryCode(name: 'Morocco', dialCode: '+212', flag: '🇲🇦'),
    CountryCode(name: 'Mozambique', dialCode: '+258', flag: '🇲🇿'),
    CountryCode(name: 'Myanmar', dialCode: '+95', flag: '🇲🇲'),
    CountryCode(name: 'Namibia', dialCode: '+264', flag: '🇳🇦'),
    CountryCode(name: 'Nepal', dialCode: '+977', flag: '🇳🇵'),
    CountryCode(name: 'Netherlands', dialCode: '+31', flag: '🇳🇱'),
    CountryCode(name: 'New Zealand', dialCode: '+64', flag: '🇳🇿'),
    CountryCode(name: 'Nicaragua', dialCode: '+505', flag: '🇳🇮'),
    CountryCode(name: 'Niger', dialCode: '+227', flag: '🇳🇪'),
    CountryCode(name: 'Nigeria', dialCode: '+234', flag: '🇳🇬'),
    CountryCode(name: 'North Korea', dialCode: '+850', flag: '🇰🇵'),
    CountryCode(name: 'North Macedonia', dialCode: '+389', flag: '🇲🇰'),
    CountryCode(name: 'Norway', dialCode: '+47', flag: '🇳🇴'),
    CountryCode(name: 'Oman', dialCode: '+968', flag: '🇴🇲'),
    CountryCode(name: 'Pakistan', dialCode: '+92', flag: '🇵🇰'),
    CountryCode(name: 'Palestine', dialCode: '+970', flag: '🇵🇸'),
    CountryCode(name: 'Panama', dialCode: '+507', flag: '🇵🇦'),
    CountryCode(name: 'Papua New Guinea', dialCode: '+675', flag: '🇵🇬'),
    CountryCode(name: 'Paraguay', dialCode: '+595', flag: '🇵🇾'),
    CountryCode(name: 'Peru', dialCode: '+51', flag: '🇵🇪'),
    CountryCode(name: 'Philippines', dialCode: '+63', flag: '🇵🇭'),
    CountryCode(name: 'Poland', dialCode: '+48', flag: '🇵🇱'),
    CountryCode(name: 'Portugal', dialCode: '+351', flag: '🇵🇹'),
    CountryCode(name: 'Qatar', dialCode: '+974', flag: '🇶🇦'),
    CountryCode(name: 'Romania', dialCode: '+40', flag: '🇷🇴'),
    CountryCode(name: 'Russia', dialCode: '+7', flag: '🇷🇺'),
    CountryCode(name: 'Rwanda', dialCode: '+250', flag: '🇷🇼'),
    CountryCode(name: 'Saudi Arabia', dialCode: '+966', flag: '🇸🇦'),
    CountryCode(name: 'Senegal', dialCode: '+221', flag: '🇸🇳'),
    CountryCode(name: 'Serbia', dialCode: '+381', flag: '🇷🇸'),
    CountryCode(name: 'Seychelles', dialCode: '+248', flag: '🇸🇨'),
    CountryCode(name: 'Sierra Leone', dialCode: '+232', flag: '🇸🇱'),
    CountryCode(name: 'Singapore', dialCode: '+65', flag: '🇸🇬'),
    CountryCode(name: 'Slovakia', dialCode: '+421', flag: '🇸🇰'),
    CountryCode(name: 'Slovenia', dialCode: '+386', flag: '🇸🇮'),
    CountryCode(name: 'Somalia', dialCode: '+252', flag: '🇸🇴'),
    CountryCode(name: 'South Africa', dialCode: '+27', flag: '🇿🇦'),
    CountryCode(name: 'South Korea', dialCode: '+82', flag: '🇰🇷'),
    CountryCode(name: 'South Sudan', dialCode: '+211', flag: '🇸🇸'),
    CountryCode(name: 'Spain', dialCode: '+34', flag: '🇪🇸'),
    CountryCode(name: 'Sri Lanka', dialCode: '+94', flag: '🇱🇰'),
    CountryCode(name: 'Sudan', dialCode: '+249', flag: '🇸🇩'),
    CountryCode(name: 'Suriname', dialCode: '+597', flag: '🇸🇷'),
    CountryCode(name: 'Sweden', dialCode: '+46', flag: '🇸🇪'),
    CountryCode(name: 'Switzerland', dialCode: '+41', flag: '🇨🇭'),
    CountryCode(name: 'Syria', dialCode: '+963', flag: '🇸🇾'),
    CountryCode(name: 'Taiwan', dialCode: '+886', flag: '🇹🇼'),
    CountryCode(name: 'Tajikistan', dialCode: '+992', flag: '🇹🇯'),
    CountryCode(name: 'Tanzania', dialCode: '+255', flag: '🇹🇿'),
    CountryCode(name: 'Thailand', dialCode: '+66', flag: '🇹🇭'),
    CountryCode(name: 'Togo', dialCode: '+228', flag: '🇹🇬'),
    CountryCode(name: 'Trinidad and Tobago', dialCode: '+1', flag: '🇹🇹'),
    CountryCode(name: 'Tunisia', dialCode: '+216', flag: '🇹🇳'),
    CountryCode(name: 'Turkey', dialCode: '+90', flag: '🇹🇷'),
    CountryCode(name: 'Turkmenistan', dialCode: '+993', flag: '🇹🇲'),
    CountryCode(name: 'Uganda', dialCode: '+256', flag: '🇺🇬'),
    CountryCode(name: 'Ukraine', dialCode: '+380', flag: '🇺🇦'),
    CountryCode(name: 'United Arab Emirates', dialCode: '+971', flag: '🇦🇪'),
    CountryCode(name: 'United Kingdom', dialCode: '+44', flag: '🇬🇧'),
    CountryCode(name: 'United States', dialCode: '+1', flag: '🇺🇸'),
    CountryCode(name: 'Uruguay', dialCode: '+598', flag: '🇺🇾'),
    CountryCode(name: 'Uzbekistan', dialCode: '+998', flag: '🇺🇿'),
    CountryCode(name: 'Vatican City', dialCode: '+39', flag: '🇻🇦'),
    CountryCode(name: 'Venezuela', dialCode: '+58', flag: '🇻🇪'),
    CountryCode(name: 'Vietnam', dialCode: '+84', flag: '🇻🇳'),
    CountryCode(name: 'Yemen', dialCode: '+967', flag: '🇾🇪'),
    CountryCode(name: 'Zambia', dialCode: '+260', flag: '🇿🇲'),
    CountryCode(name: 'Zimbabwe', dialCode: '+263', flag: '🇿🇼'),
  ];
  
  // Default selected country code
  CountryCode _selectedCountryCode = CountryCode(name: 'Morocco', dialCode: '+212', flag: '🇲🇦');

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
                    final countryCode = _countryCodes[index];
                    return ListTile(
                      leading: Text(countryCode.flag, style: const TextStyle(fontSize: 24)),
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
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Centered Title
                    SizedBox(height: size.height * 0.02),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Register to report',
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
                                TextSpan(text: 'city issues — '),
                                TextSpan(
                                  text: 'together we improve\nwith CityFix',
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
                    
                    SizedBox(height: size.height * 0.04),
                    
                    // Full Name
                    TextFormField(
                      controller: _fullNameController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Full Name',
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
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Email
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Email',
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
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Phone number with country code
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Country code selector
                        InkWell(
                          onTap: _showCountryCodePicker,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 58,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(_selectedCountryCode.flag, style: const TextStyle(fontSize: 24)),
                                const SizedBox(width: 4),
                                Text(
                                  _selectedCountryCode.dialCode, 
                                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                ),
                                Icon(
                                  Icons.arrow_drop_down, 
                                  size: 20, 
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // Phone number field
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
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
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Password
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      obscureText: _isObscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                            _isObscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscurePassword = !_isObscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      obscureText: _isObscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
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
                            _isObscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscureConfirmPassword = !_isObscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
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
                          : const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    
                    // Terms and Conditions
                    SizedBox(height: 24),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey.shade500 : Colors.grey.shade700,
                          ),
                          children: [
                            TextSpan(text: 'By signing up, you accept our '),
                            TextSpan(
                              text: 'Terms',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                    
                    // Sign in link
                    SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Already have an account? Sign In',
                          style: TextStyle(
                            color: const Color(0xFF8C61FF),
                            fontWeight: FontWeight.w500,
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
} 