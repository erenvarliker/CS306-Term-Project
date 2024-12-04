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
    -- Update the num_doctors column for each department
    UPDATE Department d
    SET num_doctors = (
        SELECT COUNT(*)
        FROM Doctor doc
        WHERE doc.department_id = d.department_id
    );

    -- Display the updated num_doctors for each department
    SELECT department_id, name AS DepartmentName, num_doctors
    FROM Department;
END$$

DELIMITER ;
