from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal, engine
from models import Base, Patient
import crud
import logging

# Initialize FastAPI
app = FastAPI()


# Dependency to get DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Endpoints
logging.basicConfig(level=logging.INFO)

@app.get("/patients")
def read_patients(db: Session = Depends(get_db)):
    try:
        logging.info("Fetching patients from the database...")
        patients = db.query(Patient).all()
        logging.info(f"Fetched {len(patients)} patients.")
        return patients
    except Exception as e:
        logging.error(f"Error fetching patients: {e}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {e}")



@app.post("/patients")
def create_patient(name: str, gender: str, age: int, db: Session = Depends(get_db)):
    return crud.create_patient(db, name, gender, age)

@app.get("/appointments")
def read_appointments(db: Session = Depends(get_db)):
    return crud.get_appointments(db)

@app.post("/appointments")
def create_appointment(doctor_id: int, patient_id: int, appointment_date: str, db: Session = Depends(get_db)):
    appointment = crud.create_appointment(db, doctor_id, patient_id, appointment_date)
    crud.create_bill(db, appointment_id=appointment.appointment_id)
    return appointment

@app.get("/bills/{appointment_id}")
def read_bill(appointment_id: int, db: Session = Depends(get_db)):
    bill = crud.get_bill_by_appointment_id(db, appointment_id)
    if not bill:
        raise HTTPException(status_code=404, detail="Bill not found")
    return bill