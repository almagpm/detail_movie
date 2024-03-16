import 'package:flutter/material.dart';
import 'package:pmsn2024/services/products_firebase.dart';

class ProductsFirebaseScreen extends StatefulWidget {
  const ProductsFirebaseScreen({super.key});

  @override
  State<ProductsFirebaseScreen> createState() => _ProductsFirebaseScreenState();
}

class _ProductsFirebaseScreenState extends State<ProductsFirebaseScreen> {
  final productsFirebase = ProductsFirebase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Hola'), ),
      body: StreamBuilder(
        stream: productsFirebase.consultar(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
              return Image.network(snapshot.data!.docs[index].get('imagen'));
            },);
          }else{
            if(snapshot.hasError){
              return Text('Error');
            }else{
              return Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }
}