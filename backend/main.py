from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy import text
from sqlalchemy.orm import Session
from database import SessionLocal, engine
from models import Base, Patient, Appointment, Bill
import crud
import logging
from fastapi import Form
from fastapi.responses import HTMLResponse

# Initialize FastAPI
app = FastAPI()


# Dependency to get DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()



#Utility Function
def generate_html_table(data, title):
    if not data:
        return f"""
        <html>
            <head><title>{title}</title></head>
            <body>
                <h1>{title}</h1>
                <p>No data available.</p>
            </body>
        </html>
        """
    # Check if data contains ORM objects or dictionaries
    if hasattr(data[0], '__dict__'):
        keys = [key for key in data[0].__dict__.keys() if key != "_sa_instance_state"]
        table_headers = "".join(f"<th>{key}</th>" for key in keys)
        table_rows = "".join(
            f"<tr>{''.join(f'<td>{getattr(row, key)}</td>' for key in keys)}</tr>"
            for row in data
        )
    else:  # If data contains dictionaries
        keys = data[0].keys()
        table_headers = "".join(f"<th>{key}</th>" for key in keys)
        table_rows = "".join(
            f"<tr>{''.join(f'<td>{row[key]}</td>' for key in keys)}</tr>"
            for row in data
        )
    return f"""
    <html>
        <head><title>{title}</title></head>
        <body>
            <h1>{title}</h1>
            <table border="1">
                <thead><tr>{table_headers}</tr></thead>
                <tbody>{table_rows}</tbody>
            </table>
        </body>
    </html>
    """


# Endpoints
logging.basicConfig(level=logging.INFO)

@app.get("/patients", response_class=HTMLResponse)
def read_patients(db: Session = Depends(get_db)):
    try:
        logging.info("Fetching patients from the database...")
        patients = db.query(Patient).all()
        logging.info(f"Fetched {len(patients)} patients.")
        return generate_html_table(patients, "Patients")
    except Exception as e:
        logging.error(f"Error fetching patients: {e}")
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {e}")



@app.post("/patients")
def create_patient(name: str, gender: str, age: int, db: Session = Depends(get_db)):
    return crud.create_patient(db, name, gender, age)

@app.get("/appointments",response_class=HTMLResponse)
def read_appointments(db: Session = Depends(get_db)):
    appointments = crud.get_appointments(db)
    return generate_html_table(appointments,"Appointments")

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



@app.get("/departments", response_class=HTMLResponse)
def read_departments(db: Session = Depends(get_db)):
    departments = crud.get_departments(db)
    return generate_html_table(departments, "Departments")


@app.get("/doctors", response_class=HTMLResponse)
def read_doctors(db: Session = Depends(get_db)):
    doctors = crud.get_doctors(db)
    return generate_html_table(doctors, "Doctors")

@app.get("/nurses", response_class=HTMLResponse)
def read_nurses(db: Session = Depends(get_db)):
    nurses = crud.get_nurses(db)
    return generate_html_table(nurses, "Nurses")

@app.get("/drugs", response_class=HTMLResponse)
def read_drugs(db: Session = Depends(get_db)):
    drugs = crud.get_drugs(db)
    return generate_html_table(drugs, "Drugs")

@app.get("/equipment", response_class=HTMLResponse)
def read_equipment(db: Session = Depends(get_db)):
    equipments = crud.get_equipment(db)
    return generate_html_table(equipments, "Equipments")

@app.get("/bills", response_class=HTMLResponse)
def read_bills(db: Session = Depends(get_db)):
    bills = crud.get_bills(db)
    return generate_html_table(bills, "Bills")

@app.get("/rooms", response_class=HTMLResponse)
def read_rooms(db: Session = Depends(get_db)):
    rooms = crud.get_rooms(db)
    return generate_html_table(rooms, "Rooms")

@app.get("/stays_in", response_class=HTMLResponse)
def read_stays_in(db: Session = Depends(get_db)):
    staysIn = crud.get_stays(db)
    return generate_html_table(staysIn, "Stays In")

@app.get("/labs", response_class=HTMLResponse)
def read_labs(db: Session = Depends(get_db)):
    labs = crud.get_labs(db)
    return generate_html_table(labs, "Labs")

@app.get("/prescriptions", response_class=HTMLResponse)
def read_prescriptions(db: Session = Depends(get_db)):
    prescriptions = crud.get_prescriptions(db)
    return generate_html_table(prescriptions, "Prescriptions")


@app.get("/rooms/availability", response_class=HTMLResponse)
def read_room_availability(db: Session = Depends(get_db)):
    try:
        # Execute the stored procedure
        result = db.execute(text("CALL GetRoomAvailability()"))
        rows = result.fetchall()  # Fetch all rows returned by the procedure

        # Convert rows to HTML table
        table_html = """
        <html>
            <head>
                <title>Room Availability</title>
            </head>
            <body>
                <h1>Available Rooms</h1>
                <table border="1">
                    <tr>
                        <th>Room ID</th>
                        <th>Room Status</th>
                    </tr>
        """
        for row in rows:
            table_html += f"<tr><td>{row.room_id}</td><td>{row.room_status}</td></tr>"

        table_html += """
                </table>
            </body>
        </html>
        """

        return HTMLResponse(content=table_html)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching room availability: {e}")

@app.get("/insert_appointment", response_class=HTMLResponse)
def insert_appointment_form():
    html_content = """
    <html>
        <head>
            <title>Insert Appointment</title>
        </head>
        <body>
            <h1>Insert Appointment</h1>
            <form action="/submit_appointment" method="post">
                <label for="doctor_id">Doctor ID:</label>
                <input type="number" id="doctor_id" name="doctor_id" required><br><br>
                <label for="patient_id">Patient ID:</label>
                <input type="number" id="patient_id" name="patient_id" required><br><br>
                <label for="appointment_date">Appointment Date:</label>
                <input type="date" id="appointment_date" name="appointment_date" required><br><br>
                <button type="submit">Submit</button>
            </form>
        </body>
    </html>
    """
    return HTMLResponse(content=html_content)

@app.post("/submit_appointment", response_class=HTMLResponse)
def submit_appointment(doctor_id: int = Form(...), patient_id: int = Form(...), appointment_date: str = Form(...), db: Session = Depends(get_db)):
    new_appointment = Appointment(doctor_id=doctor_id, patient_id=patient_id, appointment_date=appointment_date, appointment_id=None)
    db.add(new_appointment)
    db.commit()
    db.refresh(new_appointment)

    # Fetch updated tables
    appointments = db.query(Appointment).all()
    bills = db.query(Bill).all()

    appointment_data = [appointment.__dict__ for appointment in appointments]
    bill_data = [bill.__dict__ for bill in bills]

    appointment_table = generate_html_table(appointment_data, "Appointments")
    bill_table = generate_html_table(bill_data, "Bills")

    return HTMLResponse(content=appointment_table + "<br><br>" + bill_table)