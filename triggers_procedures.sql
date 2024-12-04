ALTER TABLE Department
ADD COLUMN num_doctors INT DEFAULT 0;

DELIMITER $$
CREATE TRIGGER increment_employee_count_on_doctor_add
AFTER INSERT ON Doctor
FOR EACH ROW
BEGIN
    UPDATE Department
    SET num_doctors = num_doctors + 1
    WHERE department_id = NEW.department_id;
END$$
DELIMITER ;


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

-- Adding a new doctor
INSERT INTO Doctor (doctor_id, name, department_id)
VALUES (13, 'Dr. James', 1);
DROP TRIGGER IF EXISTS trigger_name;


-- Check the Department table
SELECT * FROM Department;

DELIMITER $$
CREATE PROCEDURE get_doctors_by_department(
    IN dept_id INT
)
BEGIN
    SELECT doctor_id, name
    FROM Doctor
    WHERE department_id = dept_id;
END$$
DELIMITER ;


