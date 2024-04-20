import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseProvider {
  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'miuvetv97.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Tutor(
        id_tutor INTEGER PRIMARY KEY,
        nombre_tutor TEXT,
        celular TEXT,
        direccion TEXT,
        rut TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Paciente(
        id_paciente INTEGER PRIMARY KEY,
        nombre_paciente TEXT,
        raza TEXT,
        especie TEXT,
        edad TEXT,
        sexo TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Ficha(
        id_ficha INTEGER PRIMARY KEY,
        id_paciente INTEGER,
        id_tutor INTEGER,
        fecha TEXT,
        FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente) ON DELETE SET NULL,
        FOREIGN KEY (id_tutor) REFERENCES Tutor(id_tutor) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Cuenta(
        id_cuenta INTEGER PRIMARY KEY,
        id_tipo_cuenta INTEGER,
        precio INTEGER,
        id_metodo_pago INTEGER,
        fecha TEXT,
        nombreCliente TEXT,
        FOREIGN KEY (id_tipo_cuenta) REFERENCES Tipo_cuenta(id_tipo_cuenta) ON DELETE SET NULL,
        FOREIGN KEY (id_metodo_pago) REFERENCES Metodo_pago(id_metodo_pago) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Tipo_cuenta(
        id_tipo_cuenta INTEGER PRIMARY KEY,
        nombre_tipo_cuenta TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Metodo_pago(
        id_metodo_pago INTEGER PRIMARY KEY,
        nombre_metodo_pago TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Comentario(
        id_comentario INTEGER PRIMARY KEY,
        comentario TEXT,
        id_ficha INTEGER,
        fecha TEXT,
        tipo_comentario TEXT,
        FOREIGN KEY (id_ficha) REFERENCES Ficha(id_ficha) ON DELETE SET NULL
      )
    ''');
    await db.insert('Metodo_pago', {'nombre_metodo_pago': 'Debito'});
    await db.insert('Metodo_pago', {'nombre_metodo_pago': 'Transferencia'});
    await db.insert('Metodo_pago', {'nombre_metodo_pago': 'Credito'});
    await db.insert('Metodo_pago', {'nombre_metodo_pago': 'Efectivo'});

    await db.insert('Tipo_cuenta', {'nombre_tipo_cuenta': 'Veterinaria'});
    await db.insert('Tipo_cuenta', {'nombre_tipo_cuenta': 'Particular'});
  }
}
