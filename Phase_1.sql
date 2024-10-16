CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
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
    room_id INT PRIMARY KEY
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
    bill_id INT PRIMARY KEY,
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

CREATE TABLE Test (
    test_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    lab_id INT
);

CREATE TABLE Lab (
    lab_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
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
    
    INSERT INTO Patient (patient
