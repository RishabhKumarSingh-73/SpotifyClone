from fastapi import FastAPI
from models.base import Base
from database import engine
from routes import auth, song

app = FastAPI()

app.include_router(auth.router,prefix="/auth")
app.include_router(song.router,prefix="/song")


Base.metadata.create_all(engine)

#hi