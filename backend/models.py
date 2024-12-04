from sqlalchemy import Column, Integer, String, DECIMAL, Date, ForeignKey
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Patient(Base):
    __tablename__ = "Patient"

    patient_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    age = Column(Integer, nullable=True)
    gender = Column(String(10), nullable=True)

    # Remove any unnecessary relationships if you don't need them



class Appointment(Base):
    __tablename__ = "Appointment"

    appointment_id = Column(Integer, primary_key=True, index=True)
    doctor_id = Column(Integer, nullable=True)
    patient_id = Column(Integer, ForeignKey("Patient.patient_id"))
    appointment_date = Column(String, nullable=True)

    # Ensure no invalid relationships here

class Department(Base):
    __tablename__ = "Department"

    department_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)


class Doctor(Base):
    __tablename__ = "Doctor"

    doctor_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    department_id = Column(Integer, ForeignKey("Department.department_id"))


class Nurse(Base):
    __tablename__ = "Nurse"

    nurse_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    department_id = Column(Integer, ForeignKey("Department.department_id"))


class Drug(Base):
    __tablename__ = "Drugs"

    drug_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    price = Column(DECIMAL(10, 2), nullable=False)
    expiry_date = Column(Date, nullable=False)
    availability = Column(String(50), default="Available")


class Equipment(Base):
    __tablename__ = "Equipment"

    equipment_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)

class Bill(Base):
    __tablename__ = "Bill"

    bill_id = Column(Integer, primary_key=True, index=True)
    appointment_id = Column(Integer, ForeignKey("Appointment.appointment_id"), nullable=False)
    amount = Column(DECIMAL(10, 2), nullable=False)
    status = Column(String(50), nullable=False)

class Room(Base):
    __tablename__ = "Rooms"

    room_id = Column(Integer, primary_key=True, index=True)
    room_status = Column(Integer, nullable=False)  # 0 = available, 1 = occupied

class StaysIn(Base):
    __tablename__ = "Stays_In"

    stay_id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("Patient.patient_id"), nullable=False)
    room_id = Column(Integer, ForeignKey("Rooms.room_id"), nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=True)  # Nullable to handle ongoing stays

class Lab(Base):
    __tablename__ = "Lab"

    lab_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)

class Prescription(Base):
    __tablename__ = "Prescription"

    prescription_id = Column(Integer, primary_key=True, index=True)
    appointment_id = Column(Integer, ForeignKey("Appointment.appointment_id"), nullable=False)
