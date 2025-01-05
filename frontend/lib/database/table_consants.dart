
// SQL Commands for Table Creation
const String CREATE_PRODUCT_TABLE = '''
CREATE TABLE IF NOT EXISTS product(
id INTEGER PRIMARY KEY AUTOINCREMENT,
title TEXT UNIQUE NOT NULL,
price REAL NOT NULL,
image_path VARCHAR(255),
quantity INTEGER NOT NULL,
unit TEXT,
description TEXT,
is_fav INTEGER DEFAULT 0,
status TEXT,
created_at TEXT,
updated_at TEXT
);
''';

const String CREATE_ORDER_TABLE = '''
CREATE TABLE IF NOT EXISTS orders(
id INTEGER PRIMARY KEY AUTOINCREMENT,
product_id INTEGER NOT NULL,
quantity INTEGER NOT NULL,
total REAL NOT NULL,
name TEXT NOT NULL,
phone TEXT NOT NULL,
address TEXT,
email TEXT,
location TEXT,
city TEXT,
pincode TEXT,
status TEXT,
created_at TEXT,
updated_at TEXT,
FOREIGN KEY(product_id) REFERENCES product(id)
);
''';
