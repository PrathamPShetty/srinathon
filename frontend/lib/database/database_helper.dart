import 'package:farm_link_ai/database/table_consants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _dbName = 'app_database.db';

  static const int _dbVersion = 1;

  static Database? _database;

  /// Get the database instance
  static Future<Database> _getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  /// Create database tables
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(CREATE_PRODUCT_TABLE);
    await db.execute(CREATE_ORDER_TABLE);
  }

  /// Close the database
  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  /// Insert a product
  static Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await _getDatabase();
    return await db.insert('product', product, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Retrieve all products
  static Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await _getDatabase();
    return await db.query('product', orderBy: 'created_at DESC');
  }

  /// Retrieve a product by ID
  static Future<Map<String, dynamic>?> getProductById(int id) async {
    final db = await _getDatabase();
    final result = await db.query(
      'product',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Update a product
  static Future<int> updateProduct(int id, Map<String, dynamic> product) async {
    final db = await _getDatabase();
    return await db.update(
      'product',
      product,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete a product
  static Future<int> deleteProduct(int id) async {
    final db = await _getDatabase();
    return await db.delete(
      'product',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Insert an order
  static Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await _getDatabase();
    return await db.insert('orders', order, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Retrieve all orders
  static Future<List<Map<String, dynamic>>> getAllOrders() async {
    final db = await _getDatabase();
    return await db.query('orders', orderBy: 'created_at DESC');
  }

  /// Retrieve an order by ID
  static Future<Map<String, dynamic>?> getOrderById(int id) async {
    final db = await _getDatabase();
    final result = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Update an order
  static Future<int> updateOrder(int id, Map<String, dynamic> order) async {
    final db = await _getDatabase();
    return await db.update(
      'orders',
      order,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete an order
  static Future<int> deleteOrder(int id) async {
    final db = await _getDatabase();
    return await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all data from a table
  static Future<int> clearTable(String tableName) async {
    final db = await _getDatabase();
    return await db.delete(tableName);
  }
}
