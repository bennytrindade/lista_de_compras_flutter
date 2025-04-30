import 'package:flutter/material.dart';
import 'dao.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}

class ListaDeCompras extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListaDeCompras();
}

class _ListaDeCompras extends State<ListaDeCompras> {
  List<Map<String, dynamic>> _lista = [];

  var nomeController = TextEditingController();
  var quantidadeController = TextEditingController();

  void _atualizarLista() async {
    final dados = await DataAccessObject.getItens();
    setState(() {
      _lista = dados;
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade800,
        title: Text("Lista de Compras", style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: _lista.length,
        itemBuilder:
            (context, index) => ListTile(
              leading:
                  _lista[index]["comprado"]
                      ? Icon(Icons.check_box)
                      : Icon(Icons.check_box_outline_blank_outlined),
              subtitle: Text("Quantidade: ${_lista[index]["quantidade"]}"),
              trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {}),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            elevation: 5,
            isScrollControlled: true,
            builder:
                (_) => Container(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 120,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: nomeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Nome do Item",
                        ),
                      ),
                      TextField(
                        controller: quantidadeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Quantidade",
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (nomeController.text.isNotEmpty &&
                              quantidadeController.text.isNotEmpty) {
                            _adicionarItem(
                              nomeController.text,
                              int.parse(quantidadeController.text),
                            );
                          }
                        },
                        child: Text("Incluir"),
                      ),
                    ],
                  ),
                ),
          );
        },
      ),
    );
  }

  Future<void> _adicionarItem(String nome, int quantidade) async {
    await DataAccessObject.createItem(nome, quantidade);
    _atualizarLista();
  }
}
