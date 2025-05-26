from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import os


#postgresql://postgres:40029071@localhost:5432/musicapp
DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_engine(DATABASE_URL)

sessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)



def get_db():
    db = sessionLocal()
    try:
        yield db
    finally:
        db.close()