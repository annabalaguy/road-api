FROM python:3.8.6-buster

COPY api /api
COPY road_detector /road_detector
COPY WEIGHTS_Vincent_Halfdata_Crossentropy.h5 /WEIGHTS_Vincent_Halfdata_Crossentropy.h5

# NOM DU MODELE A CHANGER :ci dessus, copier dans l'environnement, le même Nom que le modèle enregistré sur GCP

COPY requirements.txt /requirements.txt

RUN pip install -r requirements.txt

CMD uvicorn api.fast:app --host 0.0.0.0 --port $PORT
