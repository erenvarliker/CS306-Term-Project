
-- EGE
DELIMITER $$

CREATE PROCEDURE CalculateAndCreateDynamicBill(
    IN appointmentID INT,
    IN doctorID INT,
    OUT finalAmount DECIMAL(10, 2)
)
BEGIN
    DECLARE departmentCharge DECIMAL(10, 2);

    -- Fetch the department's billing rate
    SELECT d.billing_rate
    INTO departmentCharge
    FROM Doctor doc
    INNER JOIN Department d ON doc.department_id = d.department_id
    WHERE doc.doctor_id = doctorID;

    SET finalAmount = departmentCharge;

    -- Insert the calculated bill into the Bill table
    INSERT INTO Bill (appointment_id, amount, status)
    VALUES (appointmentID, finalAmount, 'Unpaid');
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER AfterAppointmentInsert
AFTER INSERT ON Appointment
FOR EACH ROW
BEGIN
    DECLARE calculatedAmount DECIMAL(10, 2);

    -- Call the procedure to calculate and insert the bill
    CALL CalculateAndCreateDynamicBill(
        NEW.appointment_id,
        NEW.doctor_id,
        calculatedAmount
    );
END$$

DELIMITER ;

--

ALTER TABLE Drugs ADD COLUMN availability VARCHAR(50) DEFAULT 'Available';

DELIMITER $$
CREATE TRIGGER UpdateDrugAvailability
AFTER INSERT ON Includes
FOR EACH ROW
BEGIN
    UPDATE Drugs
    SET availability = 'Unavailable'
    WHERE drug_id = NEW.drug_id
      AND expiry_date < CURRENT_DATE;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE CalculatePatientDrugCost(IN patientID INT, OUT totalCost DECIMAL(10, 2))
BEGIN
    -- Calculate the total cost of drugs prescribed to a patient
    SELECT SUM(d.price) INTO totalCost
    FROM Drugs d
    JOIN Includes i ON d.drug_id = i.drug_id
    JOIN Prescription p ON i.prescription_id = p.prescription_id
    JOIN Appointment a ON p.appointment_id = a.appointment_id
    WHERE a.patient_id = patientID;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER Auto_Update_Room_Availability
AFTER UPDATE ON Stays_In
FOR EACH ROW
BEGIN
    IF NEW.end_date = CURRENT_DATE THEN
        UPDATE Rooms
        SET room_status = 0
        WHERE room_id = NEW.room_id;
    END IF;
END$$


DELIMITER $$

CREATE PROCEDURE GetRoomAvailability()
BEGIN
    SELECT room_id, room_status
    FROM Rooms
    WHERE room_status = 0;
END$$

DELIMITER ;

--teo a
ALTER TABLE Department
ADD COLUMN num_doctors INT DEFAULT 0;

DELIMITER $$
CREATE TRIGGER decrement_employee_count_on_doctor_delete
AFTER DELETE ON Doctor
FOR EACH ROW
BEGIN
    UPDATE Department
    SET num_doctors = num_doctors - 1
    WHERE department_id = OLD.department_id;
END$$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE UpdateNumDoctors()
BEGIN
    UPDATE Department d
    SET num_doctors = (
        SELECT COUNT(*)
        FROM Doctor doc
        WHERE doc.department_id = d.department_id
    );

    SELECT department_id, name AS DepartmentName, num_doctors
    FROM Department;
END$$

DELIMITER ;
