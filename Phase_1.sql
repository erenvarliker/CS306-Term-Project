CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
 	billing_rate DECIMAL(10, 2) NOT NULL DEFAULT 100.00
);

CREATE TABLE Nurse (
    nurse_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10)
);

CREATE TABLE Rooms (
    room_id INT PRIMARY KEY,
    room_status INT
    );

CREATE TABLE Stays_In (
    stay_id INT PRIMARY KEY,
    patient_id INT,
    room_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    doctor_id INT,
    patient_id INT,
    appointment_date DATE,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

CREATE TABLE Bill (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    amount DECIMAL(10, 2),
    status VARCHAR(50),
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

CREATE TABLE Prescription (
    prescription_id INT PRIMARY KEY,
    appointment_id INT,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

CREATE TABLE Drugs (
    drug_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2),
    expiry_date DATE
);

CREATE TABLE Includes (
    prescription_id INT,
    drug_id INT,
    PRIMARY KEY (prescription_id, drug_id),
    FOREIGN KEY (prescription_id) REFERENCES Prescription(prescription_id),
    FOREIGN KEY (drug_id) REFERENCES Drugs(drug_id)
);

CREATE TABLE Lab (
    lab_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Test (
    test_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    lab_id INT,
    FOREIGN KEY (lab_id) REFERENCES Lab(lab_id)
);

CREATE TABLE Conducts (
    lab_id INT,
    test_id INT,
    PRIMARY KEY (lab_id, test_id),
    FOREIGN KEY (lab_id) REFERENCES Lab(lab_id),
    FOREIGN KEY (test_id) REFERENCES Test(test_id)
);

CREATE TABLE Undergoes (
    undergo_id INT PRIMARY KEY,
    patient_id INT,
    test_id INT,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (test_id) REFERENCES Test(test_id)
);

CREATE TABLE Equipment (
    equipment_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Has (
    department_id INT,
    equipment_id INT,
    PRIMARY KEY (department_id, equipment_id),
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id)
);

INSERT INTO Department (department_id, name)
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
    
    INSERT INTO Patient (patient_id, name, age, gender) VALUES
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
    (113, 'Hayko Cepkin' , 24, 'Male');

INSERT INTO Nurse (nurse_id, name, department_id) VALUES
(2565, 'Grace Lee', 2),
(5247, 'Jack Taylor', 8),
(5532, 'Isla Scott', 7),
(5541, 'Frank Thompson', 4),
(7400, 'Alice Johnson', 7),
(8080, 'Emily Clark', 8),
(8505, 'Cathy Brown', 1),
(8664, 'David Wilson', 1),
(8874, 'Henry King', 1),
(9216, 'Bob Smith', 8);

INSERT INTO Doctor (doctor_id, name, department_id) VALUES
(877, 'Dr. Jane Smith', 1),
(4694, 'Dr. Olivia Lewis', 3),
(4762, 'Dr. David Thompson', 4),
(6139, 'Dr. Michael Brown', 8),
(6337, 'Dr. Ethan White', 6),
(7581, 'Dr. Emily Davis', 8),
(8049, 'Dr. Henry King', 7),
(8162, 'Dr. Grace Scott', 5),
(8422, 'Dr. Sarah Johnson', 1),
(9900, 'Dr. John Doe', 9);


INSERT INTO Appointment (appointment_id, doctor_id, patient_id, appointment_date) VALUES
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


INSERT INTO Rooms (room_id, room_status) VALUES
(1263, 0),
(3910, 1),
(4135, 1),
(5943, 1),
(7181, 1),
(7225, 0),
(7497, 0),
(8296, 1),
(9470, 0),
(9804, 0);

INSERT INTO Stays_In (stay_id, patient_id, room_id, start_date, end_date) VALUES
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

INSERT INTO Bill (bill_id, appointment_id, amount, status) VALUES
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

INSERT INTO Prescription (prescription_id, appointment_id) VALUES
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

INSERT INTO Drugs (drug_id, name, price, expiry_date) VALUES
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

INSERT INTO Includes (prescription_id, drug_id) VALUES
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

INSERT INTO Lab (lab_id, name) VALUES
(101, 'Pathology Lab'),
(102, 'Radiology Lab'),
(103, 'MRI Lab'),
(104, 'Biochemistry Lab'),
(105, 'CT Scan Lab'),
(106, 'Cardiology Lab'),
(107, 'Microbiology Lab'),
(108, 'Hematology Lab'),
(109, 'Allergy Testing Lab'),
(110, 'Virology Lab');


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
(10, 'COVID-19 Test', 110);

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
(10,698, 10);

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
(10, 'Infusion Pump');

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

-- try
-- INSERT INTO Appointment (appointment_id, doctor_id, patient_id, appointment_date)
-- VALUES (11, 4694, 113, '2024-12-01');

-- SELECT * FROM Bill WHERE appointment_id = 11;