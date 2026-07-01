-- Tạo database nếu chưa có
CREATE DATABASE IF NOT EXISTS school
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE school;

-- Tạo bảng nếu chưa tồn tại
CREATE TABLE IF NOT EXISTS tbl_user (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(100),
    password CHAR(64),        -- SHA-256 dạng HEX gồm 64 ký tự
    email VARCHAR(100),
    address VARCHAR(100),
    PRIMARY KEY (id)
);

-- Thêm dữ liệu
INSERT INTO tbl_user (id, username, password, email, address) VALUES
(1, 'dhgia', SHA2('123456',256), 'dhgia', 'HoChiMinhCity'),

-- Giả sử các tài khoản còn lại đều có mật khẩu là 123456
(2, 'admin', SHA2('123456',256), 'admin@dhv.edu.vn', 'HoChiMinh City'),
(3, 'user1', SHA2('123456',256), 'user1@dhv.edu.vn', 'HoChiMinh City'),
(4, 'user2', SHA2('123456',256), 'user2@dhv.du.vn', 'HoChiMinh City'),
(5, 'user3', SHA2('123456',256), 'user2@dhv.du.vn', 'HoChiMinh City'),
(6, 'user4', SHA2('123456',256), 'user2@dhv.du.vn', 'HoChiMinh City'),
(7, 'user5', SHA2('123456',256), 'user2@dhv.du.vn', 'HoChiMinh City');

-- Cập nhật AUTO_INCREMENT
ALTER TABLE tbl_user AUTO_INCREMENT = 8;