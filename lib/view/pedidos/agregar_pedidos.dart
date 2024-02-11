import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Modelo de datos para el pedido
class Pedido {
  final String sg;
  final double item;
  final double km;

  Pedido({required this.sg, required this.item, required this.km});
}

class AgregarPedidoScreen extends StatefulWidget {
  @override
  _AgregarPedidoScreenState createState() => _AgregarPedidoScreenState();
}

class _AgregarPedidoScreenState extends State<AgregarPedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _sg;
  late double _item;
  late double _km;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() {
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Pedido'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'SG'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el SG';
                  }
                  return null;
                },
                onSaved: (value) {
                  _sg = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Item'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el Item';
                  }
                  return null;
                },
                onSaved: (value) {
                  _item = double.parse(value!)!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Kilometraje'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el Kilometraje';
                  }
                  return null;
                },
                onSaved: (value) {
                  _km = double.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _agregarPedido();
                  }
                },
                child: Text('Agregar Pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _agregarPedido() {
    // Guardar el pedido en Firestore
    Pedido nuevoPedido = Pedido(sg: _sg, item: _item, km: _km);
    FirebaseFirestore.instance.collection('pedidos').add({
      'sg': nuevoPedido.sg,
      'item': nuevoPedido.item * 130,
      'km': nuevoPedido.km*2 * 232,
      'base': 2319, // Agregar el campo "base" con valor fijo 2319
      'email': _user!.email, // Agregar el correo electrónico del usuario
      'fecha_creacion': Timestamp.now(), // Agregar la fecha de creación del pedido

    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Pedido agregado correctamente'),
      ));
      // Limpiar el formulario después de agregar el pedido
      _formKey.currentState!.reset();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al agregar el pedido: $error'),
      ));
    });
  }
}
