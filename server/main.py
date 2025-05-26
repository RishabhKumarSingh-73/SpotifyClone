from fastapi import FastAPI
from models.base import Base
from database import engine
from routes import auth, song
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()


origins = [
    "http://localhost:3000",     
    "http://localhost:4200",    
    "http://127.0.0.1:5500",     
    "https://your-app.web.app",  
    "*",                         
]


app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,           
    allow_credentials=True,
    allow_methods=["*"],             
    allow_headers=["*"],            
)









app.include_router(auth.router,prefix="/auth")
app.include_router(song.router,prefix="/song")


Base.metadata.create_all(engine)

#hi