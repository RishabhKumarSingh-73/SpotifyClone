import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/sign_in.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_text_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authViewModelProvider)?.isLoading == true;

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
          data: (data) {
            showSnackBar(context, data.toString());
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignInPage()));
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
                        "SignUp.",
                        style: TextStyle(
                          fontSize: 52,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomField(
                        hintText: "name",
                        controller: nameController,
                      ),
                      const SizedBox(height: 15),
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
                        text: "SignUp",
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            await ref
                                .read(authViewModelProvider.notifier)
                                .signUpUser(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                        },
                        child: RichText(
                          text: TextSpan(
                              text: "Already have an account? ",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                    text: "Sign in",
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
