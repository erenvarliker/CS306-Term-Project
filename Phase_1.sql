CREATE TABLE sys.Department (
    department_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO sys.Department (department_id, name)
VALUES
    (1, 'Cardiology'),
    (2, 'Neurology'),
    (3, 'Orthopedics'),
    (4, 'Pediatrics'),
    (5, 'Radiology'),
    (6, 'Emergency'),
    (7, 'Oncology'),
    (8, 'General Surgery'),
    (9, 'Dermatology'),
    (10, 'Gastroenterology');
    
CREATE TABLE sys.Nurse (
    nurse_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

INSERT INTO sys.Nurse (nurse_id, name, department_id) VALUES
(FLOOR(RAND() * 10000), 'Alice Johnson', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Bob Smith', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Cathy Brown', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'David Wilson', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Emily Clark', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Frank Thompson', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Grace Lee', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Henry King', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Isla Scott', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Jack Taylor', FLOOR(RAND() * 10) + 1);

	SELECT * FROM sys.Rooms;

CREATE TABLE sys.Doctor (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

INSERT INTO sys.Doctor (doctor_id, name, department_id) VALUES
(FLOOR(RAND() * 10000), 'Dr. John Doe', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Dr. Jane Smith', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Dr. Emily Davis', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Dr. Michael Brown', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Dr. Sarah Johnson', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Dr. David Thompson', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Dr. Olivia Lewis', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Dr. Ethan White', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Dr. Grace Scott', FLOOR(RAND() * 10) + 1),
(FLOOR(RAND() * 10000), 'Dr. Henry King', FLOOR(RAND() * 10) + 1);



CREATE TABLE sys.Patient (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10)
);

INSERT INTO sys.Patient (patient_id, name, age, gender) VALUES
    (601, 'Ahmet Yurt' , 18, 'Male'),
    (123, 'Neriman Guclu' , 65, 'Female'),
    (467, 'Ege Yilmaz' , 11, 'Male'),
    (092, 'Selin Kaya' , 24, 'Female'),
    (930, 'Gonul Kirmizi' , 46, 'Female'),
    (127, 'John Brown' , 76, 'Male'),
    (203, 'Sophie Clairo' , 12, 'Female'),
    (698, 'Hakan Sayar' , 89, 'Male'),
    (450, 'Taner Tolga' , 15, 'Male'),
    (222, 'Alex Demir' , 5, 'Male'),
    (113, 'Teoman Yamacı' , 12, 'Male');

CREATE TABLE sys.Appointment (
    appointment_id INT PRIMARY KEY,
    doctor_id INT,
    patient_id INT,
    appointment_date DATE,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);





-- Insert 10 rows into Appointment table with doctor_id and patient_id that match the existing data
INSERT INTO sys.Appointment (appointment_id, doctor_id, patient_id, appointment_date) VALUES
(1, 877, 92, '2024-11-01'),
(2, 4694, 113, '2024-11-02'),
(3, 4762, 123, '2024-11-03'),
(4, 6139, 127, '2024-11-04'),
(5, 6337, 203, '2024-11-05'),
(6, 7581, 222, '2024-11-06'),
(7, 8049, 450, '2024-11-07'),
(8, 8162, 467, '2024-11-08'),
(9, 8422, 601, '2024-11-09'),
(10, 9900, 698, '2024-11-10');

CREATE TABLE sys.Rooms (
    room_id INT PRIMARY KEY,
    room_status INT
    );
    
    -- Insert 10 rows into Rooms table with random room_id and status (0 for available, 1 for occupied)
INSERT INTO sys.Rooms (room_id, room_status) VALUES
(FLOOR(RAND() * 10000), 0),
(FLOOR(RAND() * 10000), 1),
(FLOOR(RAND() * 10000), 0),
(FLOOR(RAND() * 10000), 1),
(FLOOR(RAND() * 10000), 0),
(FLOOR(RAND() * 10000), 1),
(FLOOR(RAND() * 10000), 0),
(FLOOR(RAND() * 10000), 1),
(FLOOR(RAND() * 10000), 0),
(FLOOR(RAND() * 10000), 1);

CREATE TABLE sys.Stays_In (
    stay_id INT PRIMARY KEY,
    patient_id INT,
    room_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

-- Insert 10 rows into Stays_In table with matching patient_id and room_id
INSERT INTO sys.Stays_In (stay_id, patient_id, room_id, start_date, end_date) VALUES
(1, 92, 1263, '2024-11-01', '2024-11-10'),
(2, 113, 3910, '2024-11-02', '2024-11-12'),
(3, 123, 4135, '2024-11-03', '2024-11-13'),
(4, 127, 5943, '2024-11-04', '2024-11-14'),
(5, 203, 7181, '2024-11-05', '2024-11-15'),
(6, 222, 7225, '2024-11-06', '2024-11-16'),
(7, 450, 7497, '2024-11-07', '2024-11-17'),
(8, 467, 8296, '2024-11-08', '2024-11-18'),
(9, 601, 9470, '2024-11-09', '2024-11-19'),
(10, 698, 9804, '2024-11-10', '2024-11-20');



CREATE TABLE sys.Bill (
    bill_id INT PRIMARY KEY,
    appointment_id INT,
    amount DECIMAL(10, 2),
    status VARCHAR(50),
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

-- Insert 10 rows into Bill table with random matching appointment_id from Appointment table
INSERT INTO sys.Bill (bill_id, appointment_id, amount, status) VALUES
(1, 4, 250.00, 'Paid'),
(2, 2, 300.50, 'Unpaid'),
(3, 7, 150.75, 'Paid'),
(4, 1, 500.00, 'Unpaid'),
(5, 9, 450.25, 'Paid'),
(6, 5, 220.00, 'Unpaid'),
(7, 8, 100.00, 'Paid'),
(8, 10, 375.00, 'Unpaid'),
(9, 6, 180.00, 'Paid'),
(10, 3, 400.00, 'Unpaid');

CREATE TABLE sys.Prescription (
    prescription_id INT PRIMARY KEY,
    appointment_id INT,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

-- Insert 10 rows into Prescription table with random matching appointment_id from Appointment table
INSERT INTO sys.Prescription (prescription_id, appointment_id) VALUES
(1, 3),
(2, 1),
(3, 7),
(4, 5),
(5, 9),
(6, 2),
(7, 6),
(8, 4),
(9, 8),
(10, 10);



CREATE TABLE sys.Drugs (
    drug_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2),
    expiry_date DATE
);

-- Insert 10 rows into Drugs table
INSERT INTO sys.Drugs (drug_id, name, price, expiry_date) VALUES
(1, 'Paracetamol', 5.50, '2025-06-15'),
(2, 'Ibuprofen', 8.25, '2025-08-20'),
(3, 'Amoxicillin', 12.00, '2026-01-10'),
(4, 'Cetirizine', 4.75, '2025-09-12'),
(5, 'Aspirin', 6.00, '2025-12-05'),
(6, 'Metformin', 15.30, '2026-03-01'),
(7, 'Lisinopril', 18.50, '2026-05-18'),
(8, 'Atorvastatin', 20.00, '2026-07-25'),
(9, 'Azithromycin', 10.75, '2025-11-30'),
(10, 'Omeprazole', 9.50, '2025-10-20');



CREATE TABLE sys.Includes (
    prescription_id INT,
    drug_id INT,
    PRIMARY KEY (prescription_id, drug_id),
    FOREIGN KEY (prescription_id) REFERENCES Prescription(prescription_id),
    FOREIGN KEY (drug_id) REFERENCES Drugs(drug_id)
);

-- Insert 10 rows into Includes table with matching prescription_id and drug_id from Prescription and Drugs tables
INSERT INTO sys.Includes (prescription_id, drug_id) VALUES
(1, 3),
(2, 5),
(3, 1),
(4, 8),
(5, 2),
(6, 4),
(7, 7),
(8, 6),
(9, 9),
(10, 10);

CREATE TABLE Test (
    test_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    lab_id INT,
    FOREIGN KEY (lab_id) REFERENCES Lab(lab_id)
);

CREATE TABLE Lab (
    lab_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
-- Insert 10 rows into Lab table
INSERT INTO sys.Lab (lab_id, name) VALUES
(101, 'Pathology Lab'),
(102, 'Radiology Lab'),
(103, 'MRI Lab'),
(104, 'Biochemistry Lab'),
(105, 'CT Scan Lab'),
(106, 'Cardiology Lab'),
(107, 'Microbiology Lab'),
(108, 'Hematology Lab'),
(109, 'Allergy Testing Lab'),
(110, 'Virology Lab');

-- Insert 10 rows into Test table with matching lab_id from Lab table
INSERT INTO Test (test_id, name, lab_id) VALUES
(1, 'Blood Test', 101),
(2, 'X-Ray', 102),
(3, 'MRI Scan', 103),
(4, 'Urine Test', 104),
(5, 'CT Scan', 105),
(6, 'ECG', 106),
(7, 'Liver Function Test', 107),
(8, 'Cholesterol Test', 108),
(9, 'Allergy Test', 109),
(10, 'COVID-19 Test', 110);

SELECT * FROM Test;
CREATE TABLE sys.Conducts (
    lab_id INT,
    test_id INT,
    PRIMARY KEY (lab_id, test_id),
    FOREIGN KEY (lab_id) REFERENCES Lab(lab_id),
    FOREIGN KEY (test_id) REFERENCES Test(test_id)
);
-- Insert 10 rows into Conducts table with matching lab_id and test_id from Lab and Test tables
INSERT INTO Conducts (lab_id, test_id) VALUES
(101, 1),
(102, 2),
(103, 3),
(104, 4),
(105, 5),
(106, 6),
(107, 7),
(108, 8),
(109, 9),
(110, 10);

CREATE TABLE Undergoes (
    undergo_id INT PRIMARY KEY,
    patient_id INT,
    test_id INT,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (test_id) REFERENCES Test(test_id)
);

-- Insert 10 rows into Undergoes table with matching patient_id and test_id from Patient and Test tables
INSERT INTO Undergoes (undergo_id, patient_id, test_id) VALUES
(1, 92, 1),
(2, 113, 2),
(3, 123, 3),
(4, 127, 4),
(5, 203, 5),
(6, 222, 6),
(7, 450, 7),
(8, 467, 8),
(9, 601, 9),
(10, 698, 10);

CREATE TABLE Equipment (
    equipment_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Insert 10 rows into Equipment table
INSERT INTO Equipment (equipment_id, name) VALUES
(1, 'X-Ray Machine'),
(2, 'MRI Scanner'),
(3, 'CT Scanner'),
(4, 'Ultrasound Machine'),
(5, 'ECG Machine'),
(6, 'Defibrillator'),
(7, 'Ventilator'),
(8, 'Anesthesia Machine'),
(9, 'Surgical Table'),
(10, 'Infusion Pump');

CREATE TABLE Has (
    department_id INT,
    equipment_id INT,
    PRIMARY KEY (department_id, equipment_id),
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id)
);

-- Insert 10 rows into Has table with matching department_id and equipment_id from Department and Equipment tables
INSERT INTO Has (department_id, equipment_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);
