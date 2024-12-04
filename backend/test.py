from database import SessionLocal
from sqlalchemy import text  # Import the text module for raw SQL queries

db = SessionLocal()
try:
    # Use text() for raw SQL queries
    result = db.execute(text("SELECT * FROM Patient LIMIT 1")).fetchall()
    print(result)
except Exception as e:
    print("Database connection failed:", e)
finally:
    db.close()
