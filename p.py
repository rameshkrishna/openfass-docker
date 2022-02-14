from pydantic import BaseSettings
class Settings(BaseSettings):
    my_secret_data: str

    class Config:
        secrets_dir = '/var/openfaas/secrets'

settings = Settings()
print(settings)
