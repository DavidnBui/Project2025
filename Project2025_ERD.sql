CREATE TABLE "Product_category" (
  "id" int PRIMARY KEY,
  "name" varchar,
  "created_at" timestamp
);

CREATE TABLE "Products" (
  "product_id" int PRIMARY KEY,
  "product_name" varchar,
  "category_id" int,
  "created_at" timestamp
);

CREATE TABLE "Customer_Type" (
  "id" int PRIMARY KEY,
  "type_name" varchar,
  "created_at" timestamp
);

CREATE TABLE "Customer" (
  "customer_id" varchar PRIMARY KEY,
  "customer_name" varchar,
  "customer_type_id" int,
  "created_at" timestamp
);

CREATE TABLE "Regions" (
  "region_id" int PRIMARY KEY,
  "region_name" varchar,
  "created_at" timestamp
);

CREATE TABLE "Payments" (
  "payment_id" int PRIMARY KEY,
  "payment_method" varchar,
  "created_at" timestamp
);

CREATE TABLE "Orders" (
  "order_id" int,
  "order_date" date,
  "customer_id" varchar,
  "product_id" int,
  "quantity" int,
  "payment_id" int,
  "region_id" int,
  "created_at" timestamp
);

ALTER TABLE "Products" ADD FOREIGN KEY ("category_id") REFERENCES "Product_category" ("id");

ALTER TABLE "Customer" ADD FOREIGN KEY ("customer_type_id") REFERENCES "Customer_Type" ("id");

ALTER TABLE "Orders" ADD FOREIGN KEY ("customer_id") REFERENCES "Customer" ("customer_id");

ALTER TABLE "Orders" ADD FOREIGN KEY ("product_id") REFERENCES "Products" ("product_id");

ALTER TABLE "Orders" ADD FOREIGN KEY ("payment_id") REFERENCES "Payments" ("payment_id");

ALTER TABLE "Orders" ADD FOREIGN KEY ("region_id") REFERENCES "Regions" ("region_id");
