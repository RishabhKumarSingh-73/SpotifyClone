from fastapi import HTTPException, Header
import jwt


def auth_middleware(x_auth_token = Header()):
    try:
        #get token from the header
        if not x_auth_token:
            raise HTTPException(401,"no authentic token")

        #decode the token
        verified_token = jwt.decode(x_auth_token,"password_key",['HS256'])

        if not verified_token:
            raise HTTPException(401,"the token is tampered or not authentic")

        uid  = verified_token.get('id')
        return {'id':uid , 'token':x_auth_token}
    except jwt.PyJWTError:
        raise HTTPException(401,"token is not valid, authorization failed")