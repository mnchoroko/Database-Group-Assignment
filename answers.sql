-- 1. Customer Table
CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    billing_address TEXT,
    shipping_address TEXT
);

-- 2. Brand Table
CREATE TABLE Brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- 3. Product Category Table (self-referencing for hierarchy)
CREATE TABLE Product_Category (
    product_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT NULL,
    CONSTRAINT fk_parent_category FOREIGN KEY (parent_category_id) REFERENCES Product_Category(product_category_id)
        ON DELETE SET NULL
);

-- 4. Product Table
CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    product_category_id INT NOT NULL,
    brand_id INT NOT NULL,
    description TEXT,
    base_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_product_category FOREIGN KEY (product_category_id) REFERENCES Product_Category(product_category_id),
    CONSTRAINT fk_brand FOREIGN KEY (brand_id) REFERENCES Brand(brand_id)
);

-- 5. Product Variation Table
CREATE TABLE Product_Variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    price DECIMAL(10,2), -- nullable, if NULL use Product.base_price
    stock_quantity INT DEFAULT 0,
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- 6. Attribute Category Table
CREATE TABLE Attribute_Category (
    attribute_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 7. Attribute Type Table
CREATE TABLE Attribute_Type (
    attribute_type_id INT AUTO_INCREMENT PRIMARY KEY,
    attribute_category_id INT NOT NULL,
    type_name VARCHAR(100) NOT NULL,
    CONSTRAINT fk_attribute_category FOREIGN KEY (attribute_category_id) REFERENCES Attribute_Category(attribute_category_id)
);

-- 8. Product Attribute Table (links Product Variation to Attributes)
CREATE TABLE Product_Attribute (
    product_attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    variation_id INT NOT NULL,
    attribute_type_id INT NOT NULL,
    attribute_value VARCHAR(100) NOT NULL,
    CONSTRAINT fk_variation FOREIGN KEY (variation_id) REFERENCES Product_Variation(variation_id),
    CONSTRAINT fk_attribute_type FOREIGN KEY (attribute_type_id) REFERENCES Attribute_Type(attribute_type_id)
);

-- 9. Size Category Table
CREATE TABLE Size_Category (
    size_category_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_name VARCHAR(100) NOT NULL
);

-- 10. Size Option Table
CREATE TABLE Size_Option (
    size_option_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_id INT NOT NULL,
    size_value VARCHAR(50) NOT NULL,
    CONSTRAINT fk_size_category FOREIGN KEY (size_category_id) REFERENCES Size_Category(size_category_id)
);

-- 11. Colour Table
CREATE TABLE Colour (
    colour_id INT AUTO_INCREMENT PRIMARY KEY,
    colour_name VARCHAR(50) NOT NULL,
    hex_code VARCHAR(7) -- e.g., #FFFFFF
);

-- 12. Product Image Table
CREATE TABLE Product_Image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    variation_id INT NULL,
    image_url VARCHAR(255) NOT NULL,
    alt_text VARCHAR(255),
    CONSTRAINT fk_image_product FOREIGN KEY (product_id) REFERENCES Product(product_id),
    CONSTRAINT fk_image_variation FOREIGN KEY (variation_id) REFERENCES Product_Variation(variation_id)
);

-- 13. Order Table
CREATE TABLE `Order` (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- 14. Order Details Table (to link orders with product variations and quantity)
CREATE TABLE Order_Details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    variation_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_order DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES `Order`(order_id),
    CONSTRAINT fk_order_variation FOREIGN KEY (variation_id) REFERENCES Product_Variation(variation_id)
);
