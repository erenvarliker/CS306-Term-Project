from sqlalchemy import text
from sqlalchemy.orm import Session
from models import Patient, Appointment, Department, Doctor, Nurse, Drug, Equipment, Bill, Room, StaysIn, Lab, Prescription

# Patients
def get_patients(db: Session):
    return db.query(Patient).all()

def create_patient(db: Session, patient_id: int, name: str, gender: str, age: int):
    try:
        new_patient = Patient(patient_id=patient_id, name=name, gender=gender, age=age)
        db.add(new_patient)
        db.commit()
        db.refresh(new_patient)
        return new_patient
    except Exception as e:
        db.rollback()
        raise e


# Appointments
def get_appointments(db: Session):
    return db.query(Appointment).all()

def create_appointment(db: Session, doctor_id: int, patient_id: int, appointment_date: str):
    appointment = Appointment(doctor_id=doctor_id, patient_id=patient_id, appointment_date=appointment_date)
    db.add(appointment)
    db.commit()
    db.refresh(appointment)
    return appointment

# Departments

def get_departments(db: Session):
    return db.query(Department).all()

# Doctors

def get_doctors(db: Session):
    return db.query(Doctor).all()


# Nurses
def get_nurses(db: Session):
    return db.query(Nurse).all()


#Drugs
def get_drugs(db: Session):
    return db.query(Drug).all()

#Equipment
def get_equipment(db: Session):
    return db.query(Equipment).all()

# Bills
def get_bills(db: Session):
    return db.query(Bill).all()

#Rooms 
def get_rooms(db: Session):
    return db.query(Room).all()

#Stays_In relation
def get_stays(db: Session):
    return db.query(StaysIn).all()

#Labs
def get_labs(db: Session):
    return db.query(Lab).all()

def get_prescriptions(db: Session):
    return db.query(Prescription).all()

# Room Availability (Using Stored Procedure)
def get_room_availability(db: Session):
    query = text("CALL GetRoomAvailability()")
    result = db.execute(query)
    return result

def get_stay_by_id(db: Session, stay_id: int):
    """
    Fetches a single stay from the Stays_In table by its ID.

    Args:
        db (Session): The database session.
        stay_id (int): The ID of the stay to fetch.

    Returns:
        StaysIn: The stay object if found, None otherwise.
    """
    return db.query(StaysIn).filter(StaysIn.stay_id == stay_id).first()
