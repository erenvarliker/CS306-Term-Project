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
CREATE PROCEDURE GetDepartmentDetails()
BEGIN
    SELECT 
        d.department_id,
        d.name AS DepartmentName,
        (SELECT COUNT(*) 
         FROM Doctor 
         WHERE Doctor.department_id = d.department_id) AS NumberOfDoctors
    FROM Department d;
END$$
DELIMITER ;
