
# Stappenplan

1. "DAOs" omvormen naar Services

    - Impact:

        - Aanpassen referenties naar de klasse in UI laag.

    - Voordelen:

        - Door gebruik te maken van protocol'en wordt de UI laag gescheiden van de data laag, waardoor we bijvoorbeeld gebruik kunnen maken van offline first services.

2. "WebServiceUtils" omvormen

    - Impact:

        - Aanpassen van de services die voorheen de WebServiceUtils klasse gebruikte (Als we ervoor kiezen om ook de namen van methodes aan te passen).
    
    - Voordelen:

        - De web requests worden generiek gemaakt waardoor leesbaarheid stijgt en duplicate code vermeden wordt.

3. "UserDefaultUtils" omvormen

    - Impact:

        - Aanpassen van dit util bestand heeft niet direct een impact als de originele functie namen behouden worden (en functionaliteit).

    - Voordelen:

        - Zorgt voor consistentie binnen de utils folder.

4. Models corrigeren (data laag aanmaken)

5. Mappers en DTO's aanmaken

6. UI omvormen (behalve kalender)