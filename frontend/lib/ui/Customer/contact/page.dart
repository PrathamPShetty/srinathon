import 'package:farm_link_ai/consts/text.dart';
import 'package:farm_link_ai/ui/commons/nav_bar/NavBar.dart';
import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formInfo = {
    "name": "",
    "phone": "",
    "email": "",
    "subject": "",
    "message": "",
  };

  void handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("Form submitted: $_formInfo");
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavBar(
      bodyContent: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppConstants.getintouch,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF404A3D),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        AppConstants.contacttext,
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      ..._buildTextFormFields(),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF404A3D),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          child: Text("Submit",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextFormFields() {
    return [
      _buildField(
        label: "Enter your name",
        key: "name",
        validator: (value) => value!.isEmpty ? "Please enter your name." : null,
      ),
      _buildField(
        label: "Enter your contact number",
        key: "phone",
        validator: (value) => value!.isEmpty ? "Please enter your contact number." : null,
      ),
      _buildField(
        label: "Enter your email id",
        key: "email",
        validator: (value) {
          if (value!.isEmpty) return "Please enter your email.";
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Please enter a valid email.";
          return null;
        },
      ),
      _buildField(
        label: "Enter Subject",
        key: "subject",
        validator: (value) => value!.isEmpty ? "Please enter a subject." : null,
      ),
      _buildField(
        label: "Your Message",
        key: "message",
        maxLines: 5,
        validator: (value) => value!.isEmpty ? "Please enter your message." : null,
      ),
    ];
  }

  Widget _buildField({
    required String label,
    required String key,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        maxLines: maxLines,
        validator: validator,
        onSaved: (value) => _formInfo[key] = value!,
      ),
    );
  }
}
