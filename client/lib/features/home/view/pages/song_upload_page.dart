import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/widgets/audio_waveform.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongUploadPage extends ConsumerStatefulWidget {
  const SongUploadPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongUploadPageState();
}

class _SongUploadPageState extends ConsumerState<SongUploadPage> {
  final artistController = TextEditingController();
  final songController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();

  void selectImage() async {
    final res = await imagePicker();
    if (res != null) {
      setState(() {
        selectedImage = res;
      });
    }
  }

  void selectAudio() async {
    final res = await audioPicker();
    if (res != null) {
      setState(() {
        selectedAudio = res;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    artistController.dispose();
    songController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewModelProvider.select((val) => val?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'upload song',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                if (formKey.currentState!.validate() &&
                    selectedAudio != null &&
                    selectedImage != null) {
                  await ref.read(homeViewModelProvider.notifier).uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedImage: selectedImage!,
                      artist: artistController.text,
                      songName: songController.text,
                      selectedColor: selectedColor);
                } else {
                  showSnackBar(context, "fields missing");
                }
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: selectedImage != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Image.file(selectedImage!,
                                    fit: BoxFit.fitWidth))
                            : DottedBorder(
                                color: Pallete.borderColor,
                                dashPattern: const [10, 4],
                                radius: Radius.circular(10),
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                child: SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Text(
                                        "select song to be uploaded",
                                        style: TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                )),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      selectedAudio != null
                          ? AudioWave(path: selectedAudio!.path)
                          : CustomField(
                              hintText: "pick song",
                              controller: null,
                              isReadOnly: true,
                              onTap: selectAudio),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomField(
                        hintText: "artist",
                        controller: artistController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomField(
                        hintText: "song",
                        controller: songController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ColorPicker(
                          pickersEnabled: {ColorPickerType.wheel: true},
                          color: selectedColor,
                          onColorChanged: (Color color) {
                            setState(() {
                              selectedColor = color;
                            });
                          })
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
