import "package:sqflite/sqflite.dart" as sql;

class DataAccessObject {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE itens(
      id INTEGER PRIMARY KEY AUTO INCREMENT NOT FULL,
      nome TEXT,
      quantidade INTEGER,
      comprado BOOLEAN
      );
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      "listaecompras.db",
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(String nome, int quantidade) async {
    final db = await DataAccessObject.db();
    final dados = {"nome": nome, "quantidade": quantidade, "comprado": false};
    final id = await db.insert("Itens", dados);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItens() async{
    final db = await DataAccessObject.db();
    return db.query("table", orderBy: "nome");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async{
    final db = await DataAccessObject.db();
    return db.query("itens", where: "id = ?", whereArgs: [id]);
  }

  static Future<int> updateItem(int id, String nome, String quantidade, bool comprado) async{
    final db = await DataAccessObject.db();
    final dados = {"nome": nome, "quantidade": quantidade, "comprado": comprado};
    final resultado = await db.update("itens", dados, where: "id = ?", whereArgs: [id]);
    return resultado;
  }

  static Future<void> deleteItem(int id) async {
    final db = await DataAccessObject.db();
    try {
      await db.delete("Itens", where: "id = ?", whereArgs: [id]);
    } catch (erro) {
      // ignore: avoid_print
      print("Houve um erro na exclusão: $erro");
    }
  }
}
