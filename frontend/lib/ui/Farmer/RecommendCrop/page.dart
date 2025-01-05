import 'package:flutter/material.dart';

class RecommendCrop extends StatefulWidget {
  const RecommendCrop({super.key});

  @override
  State<RecommendCrop> createState() => _RecommendCropState();
}

class _RecommendCropState extends State<RecommendCrop> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nitrogenController = TextEditingController();
  final TextEditingController _phosphorusController = TextEditingController();
  final TextEditingController _potassiumController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();
  final TextEditingController _phValueController = TextEditingController();
  final TextEditingController _rainfallController = TextEditingController();

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Collect form data
      Map<String, dynamic> formData = {
        "nitrogen": _nitrogenController.text,
        "phosphorus": _phosphorusController.text,
        "potassium": _potassiumController.text,
        "temperature": _temperatureController.text,
        "humidity": _humidityController.text,
        "phValue": _phValueController.text,
        "rainfall": _rainfallController.text,
      };

      // Show successful submission message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Form submitted successfully: $formData'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearForm() {
    _nitrogenController.clear();
    _phosphorusController.clear();
    _potassiumController.clear();
    _temperatureController.clear();
    _humidityController.clear();
    _phValueController.clear();
    _rainfallController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Recommendation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nitrogen
              TextFormField(
                controller: _nitrogenController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nitrogen (N)',
                  hintText: 'Enter nitrogen value here',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter nitrogen value';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              // Phosphorus
              TextFormField(
                controller: _phosphorusController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Phosphorus (P)',
                  hintText: 'Enter phosphorus value here',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter phosphorus value';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              // Potassium
              TextFormField(
                controller: _potassiumController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Potassium (K)',
                  hintText: 'Enter potassium value here',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter potassium value';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              // Temperature
              TextFormField(
                controller: _temperatureController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Temperature',
                  hintText: 'Enter temperature value here',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter temperature value';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              // Humidity
              TextFormField(
                controller: _humidityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Humidity',
                  hintText: 'Enter humidity value here',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter humidity value';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              // pH Value
              TextFormField(
                controller: _phValueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'pH Value',
                  hintText: 'Enter pH value here',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter pH value';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              // Rainfall
              TextFormField(
                controller: _rainfallController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rainfall',
                  hintText: 'Enter rainfall value here',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter rainfall value';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _clearForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Clear All'),
                  ),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
