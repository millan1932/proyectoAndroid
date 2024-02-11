import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerPedidosScreen extends StatefulWidget {
  @override
  _VerPedidosScreenState createState() => _VerPedidosScreenState();
}

class _VerPedidosScreenState extends State<VerPedidosScreen> {
  late User? _user;
  late DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() {
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Pedidos'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Center(
            child: Text(
              'Pedidos del usuario: ${_user?.email ?? "Desconocido"}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('Seleccionar fecha'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pedidos')
                  .where('email', isEqualTo: _user?.email ?? '')
                  .where('fecha_creacion', isGreaterThanOrEqualTo: _selectedDate)
                  .where('fecha_creacion', isLessThan: _selectedDate.add(Duration(days: 1))) // Filtrar por fecha exacta
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    double total = 0;
                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        total += data['item'] + data['km'] + data['base'];
                        return ListTile(
                          title: Text(data['sg']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Item: ${data['item']}'),
                              Text('KM: ${data['km']}'),
                              Text('Base: ${data['base']}'),
                              Text('Email: ${data['email']}'),
                              Divider(),
                            ],
                          ),
                        );
                      }).toList()..add(
                        ListTile(
                          title: Text('Total Incluye descuento del 13,75%'),
                          subtitle: Text('Ganancias: ${(total * 0.8625).toStringAsFixed(2)}'),
                        ),
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
