import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileForm(),
    );
  }
}

class ProfileForm extends StatefulWidget {
  const ProfileForm({Key? key}) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _interestsController = TextEditingController();
  String? _selectedLanguage = 'English';

  File? _image;

  bool _receiveEmailNotifications = false;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _buildImagePreview() {
    return _image == null
        ? Container()
        : Image.file(
            _image!,
            width: 100,
            height: 100,
          );
  }

  String? _validateName(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Por favor, insira seu nome';
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua data de nascimento';
    }

    final datePattern = r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$';
    final regExp = RegExp(datePattern);

    if (!regExp.hasMatch(value)) {
      return 'Formato de data inválido. Use dd/mm/aaaa';
    }

    return null;
  }

  String? _validateCity(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Por favor, insira sua cidade';
    }
    return null;
  }

  String? _validateCountry(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Por favor, insira seu país';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulário de Perfil')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text('Complete seu perfil'),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _nameController,
              label: 'Nome',
              validator: _validateName,
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _birthdateController,
              label: 'Data de Nascimento (dd/mm/aaaa)',
              validator: _validateDate,
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _cityController,
              label: 'Cidade',
              validator: _validateCity,
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _countryController,
              label: 'País',
              validator: _validateCountry,
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _interestsController,
              label: 'Interesses',
            ),
            const SizedBox(height: 16.0),
            CustomDropdown(
              value: _selectedLanguage,
              onChanged: (newValue) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Escolher Foto de Perfil'),
            ),
            const SizedBox(height: 16.0),
            _buildImagePreview(),
            CustomSwitch(
              value: _receiveEmailNotifications,
              onChanged: (newValue) {
                setState(() {
                  _receiveEmailNotifications = newValue;
                });
              },
              label: 'Receber notificações por email',
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Processar os dados do formulário aqui
                  // Você pode acessar os campos e o estado do switch (_receiveEmailNotifications) aqui.
                }
              },
              child: const Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  CustomTextField({
    required this.controller,
    required this.label,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          validator: validator,
        ),
      ],
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;

  CustomDropdown({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: <String>['Português', 'English', 'Spanish', 'French', 'Other']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      hint: Text('Selecione o idioma preferido'),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;
  final String label;

  CustomSwitch({
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }
}
