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


ALTER TABLE Drugs ADD COLUMN availability VARCHAR(50) DEFAULT 'Available';

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