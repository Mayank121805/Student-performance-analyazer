import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'super-secret-key-123'
    MYSQL_HOST = os.getenv('MYSQLHOST')
    MYSQL_USER = os.getenv('MYSQLUSER')
    MYSQL_PASSWORD = os.getenv('MYSQLPASSWORD')
    MYSQL_DB = os.getenv('MYSQLDATABASE')
    MYSQL_PORT = int(os.getenv('MYSQLPORT', 3306))
    UPLOAD_FOLDER = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        'static',
        'uploads'
    )

    MAX_CONTENT_LENGTH = 16 * 1024 * 1024
