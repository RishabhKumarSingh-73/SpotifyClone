import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/sign_up.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPage extends ConsumerWidget {
  SignInPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(authViewModelProvider)?.isLoading == true;

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
          data: (data) {
            showSnackBar(context, data.toString());
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (_) => false);
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {});
    });

    return Scaffold(
      appBar: AppBar(),
      body: loading
          ? Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      const Text(
                        "SignIn.",
                        style: TextStyle(
                          fontSize: 52,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomField(
                        hintText: "email",
                        controller: emailController,
                      ),
                      const SizedBox(height: 15),
                      CustomField(
                        hintText: "password",
                        controller: passwordController,
                        isObscure: true,
                      ),
                      const SizedBox(height: 20),
                      CustomGradientButton(
                        text: "SignIn",
                        onTap: () async {
                          ref.watch(authViewModelProvider.notifier).signInUser(
                              email: emailController.text,
                              password: passwordController.text);
                        },
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                        child: RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                    text: "Sign up",
                                    style: TextStyle(
                                        color: Pallete.gradient2,
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
