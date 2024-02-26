import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmsn2024/database/products_database.dart';
import 'package:pmsn2024/model/products_model.dart';

class DespensaScreen extends StatefulWidget {
  const DespensaScreen({super.key});

  @override
  State<DespensaScreen> createState() => _DespensaScreenState();
}

class _DespensaScreenState extends State<DespensaScreen> {

  ProductsDatabase? productsDB;
  @override
  void initState() {
    super.initState();
    productsDB = new ProductsDatabase();
  }


  @override
  Widget build(BuildContext context) {

    final conNombre = TextEditingController();
    final conCantidad = TextEditingController();
    final conFecha = TextEditingController();

    final txtNombre = TextFormField(
      keyboardType: TextInputType.text,
      controller: conNombre,
      decoration: const InputDecoration(
        border: OutlineInputBorder()
      ),
    );

    final txtCantidad = TextFormField(
      keyboardType: TextInputType.number,
      controller: conCantidad,
      decoration: const InputDecoration(
        border: OutlineInputBorder()
      ),
    );

   

    final space = SizedBox(height: 10,);

    final txtFecha = TextFormField(
      controller:  conFecha,
      keyboardType: TextInputType.none,
      decoration: InputDecoration(
        border: OutlineInputBorder() 
        ),
      onTap: () async{
        DateTime? pickedDate = await showDatePicker(
          context: context, 
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
           lastDate: DateTime(2101)
           );

           if(pickedDate != null){
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            setState(() {
              conFecha.text = formattedDate;
            });
           }


      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi despensa: '),
        actions: [
          IconButton(onPressed: (){
            showModalBottomSheet(
              context: context, 
              builder: (context){
                return ListView(
                  padding: EdgeInsets.all(10),
                  children: [
                    txtNombre,
                    space,
                    txtCantidad,
                    space,
                    txtFecha
                  ],
                );
              },
              );
          },
           icon: Icon(Icons.shop_sharp))
        ],
        ),
        body: FutureBuilder(
          future: productsDB!.CONSULTAR(),
          builder: (context, AsyncSnapshot <List<ProductosModel>> snapshot){
            if(snapshot.hasError){
              return Center(child: Text ('Algo salio mal :( '),);
            }else{
              if(snapshot.hasData){
                return Container();
                // Se llama el snapshot data y posteriormente se retorna la informacionn del item
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            }

          },
          ),
    );
  }
}

Widget itemDespensa(ProductosModel producto){
  return Container(
    margin: EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
      color:  Colors.greenAccent,
      borderRadius: BorderRadius.circular(10),
    ),
    height: 100,
    child: Column(
      children: [
        Text('${producto.nomProducto!}'),
        Text('${producto.nomProducto!}'),
        Row (
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          IconButton(onPressed: (){
            //Show Modal deberia ir aqui para mostrar el formulario para editar
          }, icon: Icon(Icons.edit)),
          IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
        ],
        )

      ]
    ),
  );
  //En show modal se manda un contexto y un producto que puede ser nulo
}




