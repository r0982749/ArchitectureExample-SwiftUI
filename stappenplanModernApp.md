
# Stappenplan


## Stap 1: Data laag

1. DTO's aanmaken

    - Dit zijn de models die in JSON vorm ontvangen worden van de backend

2. Models herwerken

    - 

3. Mappers aanmaken

    - Om de DTO's om te zetten naar de correcte Models

## Stap 2: Service laag










## Stap 1: Data laag

1. DTO's aanmaken

    - Dit zijn de models die in JSON vorm ontvangen worden van de backend

2. Models aanmaken

    - Bestaan grotendeels al, enkel de 

3. Mappers aanmaken (om DTO's om te zetten naar Models)


## Service laag

1. "DAOs" omvormen naar Services

    - Impact:

        - Aanpassen referenties naar de klasse in UI laag.

    - Voordelen:

        - Door gebruik te maken van protocol'en wordt de UI laag gescheiden van de data laag, waardoor we bijvoorbeeld gebruik kunnen maken van offline first services.

## Util laag

1. "WebServiceUtils" omvormen

    - Impact:

        - Aanpassen van de services die voorheen de WebServiceUtils klasse gebruikte (Als we ervoor kiezen om ook de namen van methodes aan te passen).
    
    - Voordelen:

        - De web requests worden generiek gemaakt waardoor leesbaarheid stijgt en duplicate code vermeden wordt.

2. "UserDefaultUtils" omvormen

    - Impact:

        - Aanpassen van dit util bestand heeft niet direct een impact als de originele functie namen behouden worden (en functionaliteit).

    - Voordelen:

        - Zorgt voor consistentie binnen de utils folder.

## UI laag

1. UI omvormen (behalve kalender)