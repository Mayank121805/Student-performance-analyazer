import os
from urllib.parse import urlparse
import mysql.connector

def get_db_connection():
    try:
        url = urlparse(os.getenv("MYSQL_URL"))

        connection = mysql.connector.connect(
            host=url.hostname,
            user=url.username,
            password=url.password,
            database=url.path.lstrip('/'),
            port=url.port
        )

        return connection

    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None
