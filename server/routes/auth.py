import uuid
import bcrypt
from fastapi import Depends, HTTPException, Header
from middleware.token_authentication_middleware import auth_middleware
from models.user import User
from pydantic_schemas.create_user import CreateUser
from fastapi import APIRouter
from database import get_db
from sqlalchemy.orm import Session
import jwt

from pydantic_schemas.login_user import LoginUser

router = APIRouter()


@router.post('/signup', status_code=201)
def signup_page(user:CreateUser, db: Session= Depends(get_db)):
    #checking whether the user already exist or not
    user_db = db.query(User).filter(User.name == user.name).first()
    if user_db:
        raise HTTPException(400,"user exists")

    hash_pw = bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())
    ids = str(uuid.uuid4())
    user_db = User(id=ids,name=user.name,email=user.email,password=hash_pw);
    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db

@router.post('/login')
def login_user(user:LoginUser, db: Session= Depends(get_db)):
    #check if user exists or not
    user_db = db.query(User).filter(User.email == user.email).first()
    if not user_db:
        raise HTTPException(400,"user doesnt exist, pls signup")
    
    #if user exists then match password
    is_match = bcrypt.checkpw(user.password.encode(),user_db.password)

    if not is_match:
        raise HTTPException(400,"incorrect password")
    
    token = jwt.encode({
        'id': user_db.id,
    }, "password_key")
    
    return {'token':token,'user':user_db}

@router.get('/')
def get_user_data_using_token(db: Session= Depends(get_db), user_dict = Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['id']).first()

    if not user:
        raise HTTPException(404,"user not found")
    
    return user