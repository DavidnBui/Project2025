CREATE TABLE raw_sales (
	product_id int, 
	sale_date date, 
	sales_rep varchar, 
	region varchar,
	sales_amount float,
	quantity_sold int, 
	product_category varchar, 
	unit_cost float, 
	unit_price float,
	customer_type varchar,
	discount float,
	payment_method varchar,
	sales_channel varchar,
	region_and_sales_rep varchar
)

CREATE TABLE product_category (
  id SERIAL PRIMARY KEY,
  name VARCHAR,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO product_category (name)
SELECT DISTINCT product_category
FROM raw_sales;

CREATE TABLE payments (
  payment_id SERIAL PRIMARY KEY,
  payment_method VARCHAR,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO payments (payment_method)
	SELECT DISTINCT payment_method
	FROM raw_sales;

CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR,
  category_id INT REFERENCES product_category(id),
  unit_cost FLOAT,
  unit_price FLOAT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products (product_id, product_name, category_id, unit_cost, unit_price)
	SELECT DISTINCT
	rs.product_id,
    'Product ' || rs.product_id,
    pc.id,
    rs.unit_cost,
    rs.unit_price
	FROM raw_sales rs
	JOIN product_category pc ON rs.product_category = pc.name
	ON CONFLICT (product_id) DO NOTHING;

CREATE TABLE customer_type (
  id SERIAL PRIMARY KEY,
  type_name VARCHAR,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customer_type (type_name)
	SELECT DISTINCT customer_type
	FROM raw_sales;

CREATE TABLE regions (
  region_id SERIAL PRIMARY KEY,
  region_name VARCHAR,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO regions (region_name)
	SELECT DISTINCT region
	FROM raw_sales;

CREATE TABLE customer (
  customer_id VARCHAR PRIMARY KEY,
  customer_name VARCHAR,
  customer_type_id INT REFERENCES customer_type(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customer (customer_id, customer_name, customer_type_id)
	SELECT DISTINCT
    rs.sales_rep,
    rs.sales_rep,
    ct.id
	FROM raw_sales rs
	JOIN customer_type ct ON rs.customer_type = ct.type_name
	ON CONFLICT (customer_id) DO NOTHING;

CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  order_date DATE,
  customer_id VARCHAR REFERENCES customer(customer_id),
  product_id INT REFERENCES products(product_id),
  quantity INT,
  payment_id INT REFERENCES payments(payment_id),
  region_id INT REFERENCES regions(region_id),
  discount FLOAT,
  sales_amount FLOAT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO orders (order_date, customer_id, product_id, quantity, sales_amount, discount, payment_id, region_id)
	SELECT
    rs.sale_date,
    rs.sales_rep,
    rs.product_id,
    rs.quantity_sold,
    rs.sales_amount,
    rs.discount,
    p.payment_id,
    r.region_id
	FROM raw_sales rs
	JOIN payments p ON rs.payment_method = p.payment_method
	JOIN regions r ON rs.region = r.region_name;

SELECT * FROM region

DROP TABLE IF EXISTS "Customer" CASCADE;
DROP TABLE IF EXISTS "Customer_Type" CASCADE;
DROP TABLE IF EXISTS "Orders" CASCADE;
DROP TABLE IF EXISTS "Payments" CASCADE;
DROP TABLE IF EXISTS "Product_category" CASCADE;
DROP TABLE IF EXISTS "Products" CASCADE;
DROP TABLE IF EXISTS "Regions" CASCADE;