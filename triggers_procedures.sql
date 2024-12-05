
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
