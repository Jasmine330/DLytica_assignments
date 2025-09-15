import os

SECRET_KEY = os.getenv("SUPERSET_SECRET_KEY", "vLIUDBcHYmCe+Yy83bcfEozTYmkEkME++gTIaf3FtHVX7Y5n2pdUipcM")

SQLALCHEMY_DATABASE_URI = (
    "postgresql+psycopg2://postgres:postgres@postgres:5432/postgres"
)

CACHE_CONFIG = {"CACHE_TYPE": "SimpleCache"}

PUBLIC_ROLE_LIKE = "Gamma"

ROW_LIMIT = 5000
