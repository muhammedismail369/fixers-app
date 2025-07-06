import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Form keys for validation
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Custom colors
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryOrange = Color(0xFFFF6B00);

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_loginFormKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthEmailSignInRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    } else {
      _showErrorSnackBar('Please check your email and password');
    }
  }

  void _handleSignUp() {
    if (_signupFormKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthEmailSignUpRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              name: _nameController.text.trim(),
            ),
          );
    } else {
      _showErrorSnackBar('Please fill in all fields correctly');
    }
  }

  Widget _buildCustomTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    String? Function(String?)? validator,
    bool? passwordVisible,
    VoidCallback? onTogglePasswordVisibility,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText:
            isPassword && (passwordVisible == null || !passwordVisible),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primaryBlue),
          suffixIcon: isPassword && onTogglePasswordVisibility != null
              ? IconButton(
                  icon: Icon(
                    passwordVisible ?? false
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: onTogglePasswordVisibility,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryBlue, primaryOrange],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              );
            }
            return Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _showErrorSnackBar(state.message);
        } else if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (state is AuthValidationError) {
          _showErrorSnackBar(state.message);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[50]!,
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo
                Image.asset(
                  'assets/images/Logo.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 32),
                // Tab Bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: primaryOrange,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: primaryOrange,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'Login'),
                      Tab(text: 'Sign Up'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Tab Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Login Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _loginFormKey,
                          child: Column(
                            children: [
                              _buildCustomTextField(
                                label: 'Email',
                                icon: Icons.email_outlined,
                                controller: _emailController,
                                validator: _validateEmail,
                              ),
                              _buildCustomTextField(
                                label: 'Password',
                                icon: Icons.lock_outline,
                                controller: _passwordController,
                                isPassword: true,
                                validator: _validatePassword,
                                passwordVisible: _isPasswordVisible,
                                onTogglePasswordVisibility: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildGradientButton(
                                text: 'Login',
                                onPressed: _handleLogin,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Sign Up Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _signupFormKey,
                          child: Column(
                            children: [
                              _buildCustomTextField(
                                label: 'Full Name',
                                icon: Icons.person_outline,
                                controller: _nameController,
                                validator: _validateName,
                              ),
                              _buildCustomTextField(
                                label: 'Email',
                                icon: Icons.email_outlined,
                                controller: _emailController,
                                validator: _validateEmail,
                              ),
                              _buildCustomTextField(
                                label: 'Password',
                                icon: Icons.lock_outline,
                                controller: _passwordController,
                                isPassword: true,
                                validator: _validatePassword,
                                passwordVisible: _isPasswordVisible,
                                onTogglePasswordVisibility: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              _buildCustomTextField(
                                label: 'Confirm Password',
                                icon: Icons.lock_outline,
                                controller: _confirmPasswordController,
                                isPassword: true,
                                validator: _validateConfirmPassword,
                                passwordVisible: _isConfirmPasswordVisible,
                                onTogglePasswordVisibility: () {
                                  setState(() {
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              const SizedBox(height: 24),
                              _buildGradientButton(
                                text: 'Sign Up',
                                onPressed: _handleSignUp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      _showErrorSnackBar('Please enter a valid email address');
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      _showErrorSnackBar('Password must be at least 8 characters');
      return 'Password too short';
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value)) {
      _showErrorSnackBar('Password must contain both letters and numbers');
      return 'Password must contain letters and numbers';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      _showErrorSnackBar('Passwords do not match');
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      _showErrorSnackBar('Name must be at least 2 characters');
      return 'Name too short';
    }
    return null;
  }
}
