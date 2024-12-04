from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal
from models import Base, Patient
import crud
import logging
from sqlalchemy.sql import text

# Initialize FastAPI
app = FastAPI()

# Dependency to get DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Configure logging
logging.basicConfig(level=logging.INFO)

# Endpoints

# Patients
@app.get("/patients")
def read_patients(db: Session = Depends(get_db)):
    try:
        logging.info("Fetching patients from the database...")
        patients = crud.get_patients(db)
        logging.info(f"Fetched {len(patients)} patients.")
        return patients
    except Exception as e:
        logging.error(f"Error fetching patients: {e}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {e}")

@app.post("/patients")
def create_patient(name: str, gender: str, age: int, db: Session = Depends(get_db)):
    try:
        patient = crud.create_patient(db, name, gender, age)
        return patient
    except Exception as e:
        logging.error(f"Error creating patient: {e}")
        raise HTTPException(status_code=500, detail="Failed to create patient.")

# Appointments
@app.get("/appointments")
def read_appointments(db: Session = Depends(get_db)):
    try:
        appointments = crud.get_appointments(db)
        return appointments
    except Exception as e:
        logging.error(f"Error fetching appointments: {e}")
        raise HTTPException(status_code=500, detail="Failed to fetch appointments.")

@app.post("/appointments")
def create_appointment(doctor_id: int, patient_id: int, appointment_date: str, db: Session = Depends(get_db)):
    try:
        appointment = crud.create_appointment(db, doctor_id, patient_id, appointment_date)
        return appointment
    except Exception as e:
        logging.error(f"Error creating appointment: {e}")
        raise HTTPException(status_code=500, detail="Failed to create appointment.")

# Bills
@app.get("/bills/{appointment_id}")
def read_bill(appointment_id: int, db: Session = Depends(get_db)):
    try:
        bill = crud.get_bill_by_appointment_id(db, appointment_id)
        if not bill:
            raise HTTPException(status_code=404, detail="Bill not found")
        return bill
    except Exception as e:
        logging.error(f"Error fetching bill: {e}")
        raise HTTPException(status_code=500, detail="Failed to fetch bill.")

# Room Availability
@app.get("/rooms/availability")
def get_room_availability(db: Session = Depends(get_db)):
    try:
        logging.info("Fetching available rooms...")
        rooms = crud.get_room_availability(db)
        logging.info(f"Fetched {len(rooms)} available rooms.")
        return {"available_rooms": rooms}
    except Exception as e:
        logging.error(f"Error fetching room availability: {e}")
        raise HTTPException(status_code=500, detail="Failed to fetch room availability.")
