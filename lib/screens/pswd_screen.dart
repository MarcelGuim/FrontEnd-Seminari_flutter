import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminari_flutter/provider/users_provider.dart';
import 'package:seminari_flutter/widgets/Layout.dart';

class CanviarContrasenyaScreen extends StatefulWidget {
  const CanviarContrasenyaScreen({super.key});

  @override
  State<CanviarContrasenyaScreen> createState() =>
      _CanviarContrasenyaScreenState();
}

class _CanviarContrasenyaScreenState extends State<CanviarContrasenyaScreen> {
  final _formKey = GlobalKey<FormState>();
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  void dispose() {
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    return LayoutWrapper(
      title: 'Canviar Contrasenya',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, ${user.name} 👋',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildPasswordField(
                            controller: currentPassController,
                            label: 'Contrasenya actual',
                          ),
                          const SizedBox(height: 16),
                          _buildPasswordField(
                            controller: newPassController,
                            label: 'Nova contrasenya',
                          ),
                          const SizedBox(height: 16),
                          _buildPasswordField(
                            controller: confirmPassController,
                            label: 'Confirma nova contrasenya',
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (newPassController.text !=
                                    confirmPassController.text) {
                                  _showError(
                                    'Les contrasenyes no coincideixen',
                                  );
                                  return;
                                }

                                final result = await userProvider
                                    .canviarContrasenya(newPassController.text);

                                if (result == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Contrasenya actualitzada correctament!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  currentPassController.clear();
                                  newPassController.clear();
                                  confirmPassController.clear();
                                } else {
                                  _showError(result.toString());
                                }
                              }
                            },
                            icon: const Icon(Icons.lock_reset),
                            label: const Text('CANVIAR CONTRASENYA'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.lock),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator:
          (value) =>
              value == null || value.isEmpty
                  ? 'Aquest camp és obligatori'
                  : null,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
