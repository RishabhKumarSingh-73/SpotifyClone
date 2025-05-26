from models.base import Base
from sqlalchemy import Text, Column, ForeignKey
from sqlalchemy.orm import relationship

class Favourite(Base):
    __tablename__ = "favourite"

    id = Column(Text, primary_key=True)
    song_id = Column(Text, ForeignKey("song.id"))
    user_id = Column(Text, ForeignKey("users.id"))

    song = relationship('Song')
    user = relationship('User',back_populates='favourites')