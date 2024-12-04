from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Patient(Base):
    __tablename__ = "Patient"

    patient_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    age = Column(Integer, nullable=True)
    gender = Column(String(10), nullable=True)

class Appointment(Base):
    __tablename__ = "Appointment"

    appointment_id = Column(Integer, primary_key=True, index=True)
    doctor_id = Column(Integer, nullable=True)
    patient_id = Column(Integer, ForeignKey("Patient.patient_id"))
    appointment_date = Column(String, nullable=True)

# Add Bill Model for bills (if needed in APIs)
class Bill(Base):
    __tablename__ = "Bill"

    bill_id = Column(Integer, primary_key=True, index=True)
    appointment_id = Column(Integer, ForeignKey("Appointment.appointment_id"))
    amount = Column(Integer, nullable=True)
    status = Column(String(50), nullable=True)
