-- HOTEL MANAGEMENT DATABASE SETUP


-- Create DB
IF DB_ID('HotelManagement') IS NULL
    CREATE DATABASE HotelManagement;
GO

USE HotelManagement;
GO

-- DROP TABLES (Before creating Database)


IF OBJECT_ID('Payments', 'U') IS NOT NULL DROP TABLE Payments;
IF OBJECT_ID('Bookings', 'U') IS NOT NULL DROP TABLE Bookings;
IF OBJECT_ID('Staff', 'U') IS NOT NULL DROP TABLE Staff;
IF OBJECT_ID('Rooms', 'U') IS NOT NULL DROP TABLE Rooms;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;
IF OBJECT_ID('Hotels', 'U') IS NOT NULL DROP TABLE Hotels;

-- START TRANSACTION


BEGIN TRANSACTION;

-- CREATE TABLES


CREATE TABLE Hotels (
    HotelId INT PRIMARY KEY,
    Name VARCHAR(100),
    City VARCHAR(50),
    Rating DECIMAL(2,1)
);

CREATE TABLE Rooms (
    RoomId INT PRIMARY KEY,
    HotelId INT,
    RoomType VARCHAR(50),
    Price DECIMAL(10,2),
    Capacity INT,
    FOREIGN KEY (HotelId) REFERENCES Hotels(HotelId)
);

CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Country VARCHAR(50)
);

CREATE TABLE Bookings (
    BookingId INT PRIMARY KEY,
    CustomerId INT,
    RoomId INT,
    CheckIn DATE,
    CheckOut DATE,
    Status VARCHAR(20),
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
    FOREIGN KEY (RoomId) REFERENCES Rooms(RoomId)
);

CREATE TABLE Payments (
    PaymentId INT PRIMARY KEY,
    BookingId INT,
    Amount DECIMAL(10,2),
    PaymentMethod VARCHAR(50),
    PaymentDate DATE,
    FOREIGN KEY (BookingId) REFERENCES Bookings(BookingId)
);

CREATE TABLE Staff (
    StaffId INT PRIMARY KEY,
    HotelId INT,
    Name VARCHAR(100),
    Role VARCHAR(50),
    Salary DECIMAL(10,2),
    FOREIGN KEY (HotelId) REFERENCES Hotels(HotelId)
);

-- INSERT DATA (Sample + Bulk-like)


-- Hotels (50)
DECLARE @i INT = 1;
WHILE @i <= 50
BEGIN
    INSERT INTO Hotels VALUES (
        @i,
        CONCAT('Hotel_', @i),
        CASE WHEN @i % 2 = 0 THEN 'Mumbai' ELSE 'Delhi' END,
        ROUND(3 + RAND(CHECKSUM(NEWID())) * 2,1)
    );
    SET @i = @i + 1;
END

-- Customers (2000)
SET @i = 1;
WHILE @i <= 2000
BEGIN
    INSERT INTO Customers VALUES (
        @i,
        CONCAT('Customer_', @i),
        CONCAT('user', @i, '@mail.com'),
        CONCAT('98', RIGHT(ABS(CHECKSUM(NEWID())),8)),
        'India'
    );
    SET @i = @i + 1;
END

-- Rooms (2000)
SET @i = 1;
WHILE @i <= 2000
BEGIN
    INSERT INTO Rooms VALUES (
        @i,
        ABS(CHECKSUM(NEWID())) % 50 + 1,
        CASE WHEN @i % 2 = 0 THEN 'Deluxe' ELSE 'Standard' END,
        2000 + (ABS(CHECKSUM(NEWID())) % 5000),
        2 + (ABS(CHECKSUM(NEWID())) % 3)
    );
    SET @i = @i + 1;
END

-- Bookings (5000)
SET @i = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO Bookings VALUES (
        @i,
        ABS(CHECKSUM(NEWID())) % 2000 + 1,
        ABS(CHECKSUM(NEWID())) % 2000 + 1,
        DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE()),
        DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 5, GETDATE()),
        CASE WHEN @i % 5 = 0 THEN 'Cancelled' ELSE 'Completed' END
    );
    SET @i = @i + 1;
END

-- Payments (5000)
SET @i = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO Payments VALUES (
        @i,
        ABS(CHECKSUM(NEWID())) % 5000 + 1,
        1000 + (ABS(CHECKSUM(NEWID())) % 5000),
        CASE WHEN @i % 2 = 0 THEN 'Card' ELSE 'UPI' END,
        GETDATE()
    );
    SET @i = @i + 1;
END

-- Staff (500)
SET @i = 1;
WHILE @i <= 500
BEGIN
    INSERT INTO Staff VALUES (
        @i,
        ABS(CHECKSUM(NEWID())) % 50 + 1,
        CONCAT('Staff_', @i),
        CASE WHEN @i % 2 = 0 THEN 'Manager' ELSE 'Receptionist' END,
        20000 + (ABS(CHECKSUM(NEWID())) % 30000)
    );
    SET @i = @i + 1;
END

-- COMMIT


COMMIT;

-- DONE


PRINT 'Database setup completed successfully!';