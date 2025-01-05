import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../location/location.dart';
import '../../../utils/payment_utils.dart';
import 'package:farm_link_ai/consts/ip.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Service> services = [];
  List<Service> filteredServices = [];
  TextEditingController searchController = TextEditingController();
  final RazorpayUtils razorpayUtils = RazorpayUtils();
  final String razorpayKey = "rzp_test_s43gNNMNDBiA7F";

  @override
  void initState() {
    super.initState();
    _fetchServices();
    searchController.addListener(() {
      filterServices(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchServices() async {
    try {
      final response = await http.get(Uri.parse('$host:8000/api/services'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          services = data.map((json) => Service.fromJson(json)).toList();
          filteredServices = services;
        });
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      debugPrint('Error fetching services: $e');
    }
  }

  void filterServices(String query) {
    List<Service> filtered = services.where((service) {
      return service.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredServices = filtered;
    });
  }

  void _bookService(Service service, int contact, String address) async {
    try {
      final now = DateTime.now();

      final orderResponse = await razorpayUtils.createOrder(service.amount);
      if (orderResponse != null) {
        razorpayUtils.openCheckout(orderResponse, service.amount, razorpayKey);

        final response = await http.post(
          Uri.parse('$host:8000/api/bookings/'),
          body: jsonEncode({
            "user": 1,
            "service": service.id,
            "additional_service": address,
            "call": '$contact',
            "time": DateFormat('HH:mm:ss').format(now),
            "date": DateFormat('yyyy-MM-dd').format(now),
            "latitude": 231.321434,
            "longitude": 234.324342,
          }),
          headers: {'Content-Type': 'application/json'},
        );
        final bookingData = jsonDecode(response.body);
        final bookingId = bookingData['booking_id'];
        final amount = bookingData['service_price'];
      } else {
        debugPrint('Failed to create order');
      }
    } catch (e) {
      debugPrint('Error booking service: $e');
    }
  }

  void showBookingForm(Service service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Book ${service.name}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: BookingForm(service: service, bookService: _bookService),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Services', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search services...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredServices.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredServices.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  child: ListTile(
                    title: Text(filteredServices[index].name),
                    subtitle: Text(filteredServices[index].description),
                    trailing: ElevatedButton(
                      onPressed: () => showBookingForm(filteredServices[index]),
                      child: Text('Book Now'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookingForm extends StatefulWidget {
  final Service service;
  final Function(Service, int, String) bookService;

  BookingForm({
    required this.service,
    required this.bookService,
  });

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  int contact = 0;
  String address = "";

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      widget.bookService(widget.service, contact, address);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking Successful')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: contactController,
            decoration: InputDecoration(labelText: 'Contact Number'),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your contact number';
              }
              return null;
            },
            onSaved: (value) {
              contact = int.parse(value!) ?? 1234567890;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(labelText: 'Address'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Address';
              }
              return null;
            },
            onSaved: (value) {
              address = value ?? "location is Accessed";
            },
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text('Time: ${selectedTime.format(context)}'),
              IconButton(icon: Icon(Icons.access_time), onPressed: _selectTime),
            ],
          ),
          Row(
            children: [
              Text('Date: ${selectedDate.toLocal()}'.split(' ')[0]),
              IconButton(icon: Icon(Icons.calendar_today), onPressed: _selectDate),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(onPressed: _submitBooking, child: Text('Submit')),
        ],
      ),
    );
  }
}

class Service {
  final int id;
  final String name;
  final String description;
  final int amount;

  Service({required this.id, required this.name, required this.description, required this.amount});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      amount: double.parse(json['price'].toString()).toInt(),
    );
  }
}