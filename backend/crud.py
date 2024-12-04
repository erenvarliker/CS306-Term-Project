from sqlalchemy.orm import Session
from models import Patient, Appointment
from sqlalchemy.sql import text  # Import the text function for raw SQL

# Patients
def get_patients(db: Session):
    return db.query(Patient).all()

def create_patient(db: Session, name: str, gender: str, age: int):
    patient = Patient(name=name, gender=gender, age=age)
    db.add(patient)
    db.commit()
    db.refresh(patient)
    return patient

# Appointments
def get_appointments(db: Session):
    return db.query(Appointment).all()

def create_appointment(db: Session, doctor_id: int, patient_id: int, appointment_date: str):
    appointment = Appointment(doctor_id=doctor_id, patient_id=patient_id, appointment_date=appointment_date)
    db.add(appointment)
    db.commit()
    db.refresh(appointment)
    return appointment

# Bills (Placeholder if it's used)
def get_bill_by_appointment_id(db: Session, appointment_id: int):
    query = "SELECT * FROM Bill WHERE appointment_id = :appointment_id"
    result = db.execute(query, {"appointment_id": appointment_id}).fetchone()
    return dict(result) if result else None

# Room Availability (Using Stored Procedure)
def get_room_availability(db: Session):
    query = text("CALL GetRoomAvailability()")
    result = db.execute(query)
    
    return [{"room_id": row[0], "room_status": row[1]} for row in result]
