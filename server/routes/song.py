import uuid
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session

import cloudinary
import cloudinary.uploader

from database import get_db
from middleware.token_authentication_middleware import auth_middleware
from models.song import Song

# Configuration       
cloudinary.config( 
    cloud_name = "dfm9b5jpx", 
    api_key = "732623928637278", 
    api_secret = "_tgjISFg6oR452QY8Lda_YcVwLw", # Click 'View API Keys' above to copy your API secret
    secure=True
)


router = APIRouter()

@router.post('/upload')
def upload_song(
    song:UploadFile = File(...),
    thumbnail:UploadFile = File(...),
    artist: str = Form(...),
    song_name: str = Form(...),
    hex_code: str = Form(...),
    db: Session = Depends(get_db),
    auth_dict = Depends(auth_middleware)
    ):
        song_id = str(uuid.uuid4())
        song_res = cloudinary.uploader.upload(song.file,resource_type = 'auto',folder = f'songs/{song_id}')
        print(song_res)
        thumbnail_res = cloudinary.uploader.upload(thumbnail.file,resource_type='image',folder = f'songs/{song_id}')
        print(thumbnail_res)

        new_song = Song(
                id=song_id,
                song_name=song_name,
                artist= artist,
                hex_code=hex_code,
                song_url = song_res['url'],
                thumbnail_url=thumbnail_res['url'],
        )

        db.add(new_song)
        db.commit()
        db.refresh(new_song)
        return new_song

@router.get("/list")
def get_all_songs(db:Session=Depends(get_db),auth_dict=Depends(auth_middleware)):
        songs = db.query(Song).all()
        return songs