# Tic Tac Toe Neural Network

Ein künstliches neuronales Netzwerk zum Spielen von Tic Tac Toe, trainiert mit Cleve Molers Zuggenerator-Strategie.

## Übersicht

Dieses Projekt implementiert ein neuronales Netzwerk, das Tic Tac Toe spielen kann. Das Modell wird mit Trainingsdaten trainiert, die durch Spiele gegen Cleve Molers Strategie generiert werden.

## Cleve Molers Strategie

Die Strategie basiert auf Cleve Molers "TicTacToe Magic" (Chapter 11):
1. Wenn möglich, einen Gewinnzug machen
2. Wenn nötig, einen Gewinnzug des Gegners blockieren
3. Andernfalls einen zufälligen leeren Platz wählen

## Projektstruktur

```
KNN_TICTACTOE/
├── utils/
│   ├── board_to_vector.m      - Konvertiert Brett in Feature-Vektor
│   ├── check_winner.m          - Prüft auf Gewinner
│   ├── display_board.m         - Zeigt das Brett an
│   ├── get_valid_moves.m       - Findet gültige Züge
│   └── is_board_full.m         - Prüft ob Brett voll ist
├── src/
│   ├── neural_network.m       - Netzwerk-Initialisierung
│   ├── neural_network_forward.m - Forward Propagation
│   ├── neural_network_backward.m - Backward Propagation
│   ├── train.m                 - Training-Funktion
│   └── predict.m               - Vorhersage-Funktion
├── move_generator.m            - Cleve Molers Zuggenerator
├── generate_training_data.m    - Generiert Trainingsdaten
├── train_tictactoe_model.m    - Haupt-Trainingsskript
├── predict_tictactoe.m         - Vorhersage für ein Brett
├── evaluate_model.m            - Evaluierung des Modells
├── play_tictactoe.m            - Interaktives Spiel
└── README.md                   - Diese Datei
```

## Verwendung

### 1. Modell trainieren

```matlab
train_tictactoe_model
```

Dieses Skript:
- Generiert Trainingsdaten durch Spiele mit Cleve Molers Strategie
- Erstellt und trainiert ein neuronales Netzwerk
- Speichert das trainierte Modell in `models/tictactoe_model.mat`

### 2. Modell evaluieren

```matlab
evaluate_model
```

Spielt 100 Spiele gegen Cleve Molers Strategie und zeigt die Ergebnisse.

### 3. Gegen das Modell spielen

```matlab
play_tictactoe
```

Startet ein interaktives Spiel gegen das trainierte neuronale Netzwerk.

## Brett-Repräsentation

Das Brett wird als 3x3 Matrix dargestellt:
- `+1` = Spieler 1 (X)
- `-1` = Spieler 2 (O)
- `0` = leer

## Netzwerk-Architektur

- **Input**: 9 Features (flattened board state)
- **Hidden Layer**: 128 Neuronen (konfigurierbar)
- **Output**: 9 Klassen (eine für jede mögliche Position)
- **Aktivierungsfunktion**: ReLU (Hidden), Softmax (Output)
- **Loss**: Cross-Entropy

## Abhängigkeiten

Das Projekt nutzt die Aktivierungsfunktionen aus dem `NN_Car_Prices` Projekt:
- `activation_functions.m`

## Referenzen

- Cleve Moler: "Experiments in MATLAB", Chapter 11 - TicTacToe Magic
- https://www.mathworks.com/content/dam/mathworks/mathworksdot-com/moler/exm/chapters/tictactoe.pdf

