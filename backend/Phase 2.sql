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

CALL CalculatePatientDrugCost(92, @totalCost);
SELECT @totalCost; -- View the total cost result

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