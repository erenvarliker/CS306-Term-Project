from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal, engine
from models import Base, Patient
import crud
import logging

from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi import Request
from sqlalchemy import text
templates = Jinja2Templates(directory="templates")

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


@app.get("/update_page", response_class=HTMLResponse)
def get_update_page():
    html_content = """
    <html>
        <head>
            <title>Update Number of Doctors</title>
        </head>
        <body>
            <h1>Update Number of Doctors</h1>
            <form action="/update" method="post">
                <button type="submit">Update num_doctors</button>
            </form>
        </body>
    </html>
    """
    return HTMLResponse(content=html_content)

# POST endpoint to handle the button click, update num_doctors, and display results
@app.post("/update", response_class=HTMLResponse)
def update_num_doctors(db: Session = Depends(get_db)):
    try:
        # Call the stored procedure to update num_doctors
        db.execute(text("CALL UpdateNumDoctors()"))
        db.commit()

        # Fetch the updated department data
        departments = db.execute(text("SELECT department_id, name, num_doctors FROM Department")).fetchall()

        # Build an HTML table to display the updated data
        table_rows = ""
        for dept in departments:
            table_rows += f"""
            <tr>
                <td>{dept.department_id}</td>
                <td>{dept.name}</td>
                <td>{dept.num_doctors}</td>
            </tr>
            """

        html_content = f"""
        <html>
            <head>
                <title>Updated Number of Doctors</title>
            </head>
            <body>
                <h1>Updated Number of Doctors</h1>
                <table border="1">
                    <tr>
                        <th>Department ID</th>
                        <th>Department Name</th>
                        <th>Number of Doctors</th>
                    </tr>
                    {table_rows}
                </table>
            </body>
        </html>
        """
        return HTMLResponse(content=html_content)
    except Exception as e:
        html_content = f"""
        <html>
            <head>
                <title>Error</title>
            </head>
            <body>
                <h1>Error updating num_doctors: {e}</h1>
            </body>
        </html>
        """
        return HTMLResponse(content=html_content)
