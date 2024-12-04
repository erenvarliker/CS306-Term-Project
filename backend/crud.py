from sqlalchemy.orm import Session
from models import Patient, Appointment

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

