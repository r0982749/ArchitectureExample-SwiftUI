
# Stappenplan


## Stap 1: Data laag

1. DTO's aanmaken

    - Dit zijn de models die in JSON vorm ontvangen worden van de backend.

2. Models herwerken

    - Best practices toepassen voor bijvoorbeeld berekenede velden en functies.

3. Mappers aanmaken

    - Om de DTO's om te zetten naar de correcte Models.

## Stap 2: Service laag

1. Protocollen aanmaken voor alle Services

    - Door protocollen te gebruiken kunnen we later bijvoorbeeld offline first services gebruiken zonder de UI laag te moeten aanpassen.

2. "DAO's" omvormen naar Services

    - Ervoor zorgen dat de "DAO's" de best practices volgen door ze om te vormen naar Services die de protocollen implementeren.


## Stap 3: Util laag

1. "WebServiceUtils" omvormen

    - Web requests generiek maken en clean code principes toepassen (met bijvoorbeeld extensions).

    - Na dit bestand te herwerken kan de Service laag aangepast worden om op de verbeterde manier requests te sturen.

2. "UserDefaultUtils" omvormen

    - Kleine aanpassingen maken zodat deze klasse die best practices volgt.

3. Rest van de util laag opkuisen

    - Focussen op het behouden van de funtionaliteit, maar wel de best practices toepassen.

## Stap 4: UI laag

1. Ervoor zorgen dat er overal waar nodig States gebruikt worden
    
    - Zoveel mogelijk de UI te sturen met de States, en onnodige variabelen schrappen.

2. Views "cleanen"

    - Ongebruikte variabelen / functies verwijderen.
    
    - Functies verplaatsen naar extensions.

    - Partial Views inzetten om de UI laag leesbaar te maken en duplicate code te vermijden.
