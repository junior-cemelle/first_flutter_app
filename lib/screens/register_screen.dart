
import 'package:dmsn2026/firebase/email_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  String? errorMessage;
  bool _pwdVisible = false;
  bool _confirmPwdVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();
  final EmailAuth _emailAuth = EmailAuth();

  late AnimationController _bgController;
  late AnimationController _cardController;
  late AnimationController _btnShimmer;
  late Animation<double> _cardSlide;
  late Animation<double> _cardFade;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _cardSlide = Tween<double>(begin: 60, end: 0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutExpo),
    );
    _cardFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );
    _cardController.forward();

    _btnShimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _cardController.dispose();
    _btnShimmer.dispose();
    _emailController.dispose();
    _pwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final email = _emailController.text.trim();
    final pwd = _pwdController.text.trim();
    final confirm = _confirmPwdController.text.trim();

    if (email.isEmpty || pwd.isEmpty || confirm.isEmpty) {
      setState(() => errorMessage = "Llena todos los campos.");
      return;
    }
    if (pwd != confirm) {
      setState(() => errorMessage = "Las contraseñas no coinciden.");
      return;
    }
    if (pwd.length < 6) {
      setState(
          () => errorMessage = "Mínimo 6 caracteres en la contraseña.");
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final error = await _emailAuth.createUser(email, pwd);
    if (!mounted) return;
    setState(() => isLoading = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFF00FF88)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "¡Cuenta creada! Verifica tu correo para iniciar sesión.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF111827),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 4),
        ),
      );
      Navigator.pop(context);
    } else {
      setState(() => errorMessage = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Animated background — purple tint variant
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) => CustomPaint(
              painter: _RegParticlePainter(_bgController.value),
              size: MediaQuery.of(context).size,
            ),
          ),

          // Radial glow — purple
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, 0.2),
                radius: 1.1,
                colors: [
                  Color(0x227C3AED),
                  Color(0x00000000),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: AnimatedBuilder(
                  animation: _cardController,
                  builder: (_, child) => Transform.translate(
                    offset: Offset(0, _cardSlide.value),
                    child: Opacity(opacity: _cardFade.value, child: child),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111827),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color(0xFF1E2D40)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_back_ios_new_rounded,
                                    color: Color(0xFF4A5568), size: 14),
                                SizedBox(width: 6),
                                Text(
                                  "VOLVER",
                                  style: TextStyle(
                                    color: Color(0xFF4A5568),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Icon
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0A0E1A),
                          border: Border.all(
                              color: const Color(0xFF7C3AED), width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x667C3AED),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.rocket_launch_rounded,
                          color: Color(0xFFB57BFF),
                          size: 34,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "AMONG US",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "CREAR CUENTA",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFB57BFF),
                          letterSpacing: 5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Card
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: const Color(0x337C3AED), width: 1),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x227C3AED),
                              blurRadius: 40,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("CORREO ELECTRÓNICO"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _emailController,
                              hint: "usuario@correo.com",
                              icon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),
                            _buildLabel("CONTRASEÑA"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _pwdController,
                              hint: "Mínimo 6 caracteres",
                              icon: Icons.lock_outline_rounded,
                              obscure: !_pwdVisible,
                              suffix: IconButton(
                                icon: Icon(
                                  _pwdVisible
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: const Color(0xFF4A5568),
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                    () => _pwdVisible = !_pwdVisible),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildLabel("CONFIRMAR CONTRASEÑA"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _confirmPwdController,
                              hint: "Repite tu contraseña",
                              icon: Icons.lock_reset_rounded,
                              obscure: !_confirmPwdVisible,
                              suffix: IconButton(
                                icon: Icon(
                                  _confirmPwdVisible
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: const Color(0xFF4A5568),
                                  size: 20,
                                ),
                                onPressed: () => setState(() =>
                                    _confirmPwdVisible = !_confirmPwdVisible),
                              ),
                            ),

                            if (errorMessage != null) ...[
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0x22FF4E6A),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color(0x66FF4E6A)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                        Icons.error_outline_rounded,
                                        color: Color(0xFFFF4E6A),
                                        size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        errorMessage!,
                                        style: const TextStyle(
                                          color: Color(0xFFFF4E6A),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            const SizedBox(height: 28),

                            // REGISTER BUTTON — shimmer purple fill
                            // REGISTER BUTTON — igual estilo al login pero en violeta
                            AnimatedBuilder(
                              animation:
                                  _btnShimmer, // reutilizamos como _btnPulse
                              builder: (_, child) => Transform.scale(
                                scale: isLoading
                                    ? 1.0
                                    : (1.0 + (_btnShimmer.value * 0.06)),
                                child: child,
                              ),
                              child: GestureDetector(
                                onTap: isLoading ? null : _handleRegister,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: double.infinity,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    gradient: isLoading
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xFF1A2535),
                                              Color(0xFF1A2535),
                                            ],
                                          )
                                        : const LinearGradient(
                                            colors: [
                                              Color(0xFF6D28D9),
                                              Color(0xFFB57BFF),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: isLoading
                                        ? []
                                        : const [
                                            BoxShadow(
                                              color: Color(0x887C3AED),
                                              blurRadius: 20,
                                              offset: Offset(0, 6),
                                            ),
                                          ],
                                  ),
                                  child: Center(
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                    Color(0xFFB57BFF),
                                                  ),
                                            ),
                                          )
                                        : const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.person_add_alt_1_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "REGISTRARME",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15,
                                                  letterSpacing: 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                           ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: Color(0xFF7B5EA7),
      fontSize: 10,
      fontWeight: FontWeight.w700,
      letterSpacing: 2,
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) => TextField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyboardType,
    style: const TextStyle(color: Colors.white, fontSize: 15),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF2D3748), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF4A5568), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF0D1520),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1E2D40)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1E2D40)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}

// ── Shimmer gradient transform ─────────────────────────────────────────────
class _SlideGradientTransform extends GradientTransform {
  final double progress;
  const _SlideGradientTransform(this.progress);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (progress * 2 - 0.5), 0, 0);
  }
}

// ── Particle painter (purple variant) ────────────────────────────────────────
class _RegParticlePainter extends CustomPainter {
  final double progress;
  static final List<_RegParticle> _particles = List.generate(
    35,
    (i) => _RegParticle(i * 41.0),
  );

  _RegParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final t = (progress + p.offset) % 1.0;
      final x = p.x * size.width;
      final y = (1 - t) * size.height;
      final paint = Paint()
        ..color = p.color.withOpacity((1 - t) * 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(Offset(x, y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RegParticlePainter old) => true;
}

class _RegParticle {
  final double x;
  final double offset;
  final double radius;
  final Color color;

  _RegParticle(double seed)
    : x = (seed * 7.3 % 100) / 100,
      offset = (seed * 13.7 % 100) / 100,
      radius = 1.0 + (seed * 3.1 % 100) / 100 * 2,
      color = seed % 3 == 0
          ? const Color(0xFF7C3AED)
          : seed % 3 == 1
          ? const Color(0xFFB57BFF)
          : const Color(0xFF00FF88);
}
