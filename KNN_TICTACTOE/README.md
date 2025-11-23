# Tic Tac Toe Neural Network

Ein künstliches neuronales Netzwerk (KNN) zum Spielen von Tic Tac Toe, trainiert mit einem Zuggenerator basierend auf Cleve Molers Strategie.

## Übersicht

Dieses Projekt implementiert ein neuronales Netzwerk, das Tic Tac Toe spielen lernt. Das Netzwerk wird mit Trainingsdaten trainiert, die von einem optimalen Zuggenerator generiert werden (inspiriert von Cleve Molers Tic Tac Toe Implementierung).

## Projektstruktur

```
KNN_TICTACTOE/
├── src/                          # Neural Network Implementierung
│   ├── neural_network.m          # Netzwerk-Initialisierung
│   ├── neural_network_forward.m  # Forward Propagation
│   ├── neural_network_backward.m # Backward Propagation
│   └── activation_functions.m    # Aktivierungsfunktionen
├── utils/                        # Hilfsfunktionen
│   └── game_utils.m             # Spiel-Hilfsfunktionen
├── tictactoe_game.m             # Spiel-Engine
├── move_generator.m             # Zuggenerator (Cleve Moler Strategie)
├── generate_training_data.m     # Trainingsdaten-Generator
├── train_tictactoe.m            # Training-Funktion
├── predict_tictactoe.m          # Vorhersage-Funktion
├── train_tictactoe_model.m      # Haupt-Trainingsskript
├── play_tictactoe.m             # Interaktives Spiel
├── evaluate_model.m             # Modell-Evaluierung
└── README.md                    # Diese Datei
```

## Installation und Verwendung

### 1. Training des Modells

Führen Sie das Trainingsskript aus:

```matlab
train_tictactoe_model
```

Dieses Skript:
- Generiert Trainingsdaten aus 10.000 Spielen
- Initialisiert ein neuronales Netzwerk (9 Eingänge → 64 versteckte Neuronen → 9 Ausgänge)
- Trainiert das Modell mit den generierten Daten
- Speichert das trainierte Modell in `models/tictactoe_model.mat`

### 2. Spielen gegen das neuronale Netzwerk

```matlab
play_tictactoe
```

Oder mit einem geladenen Modell:

```matlab
load('models/tictactoe_model.mat', 'model');
play_tictactoe(model);
```

### 3. Modell-Evaluierung

Spielen Sie das Modell gegen den optimalen Zuggenerator:

```matlab
evaluate_model
```

Oder mit einem geladenen Modell:

```matlab
load('models/tictactoe_model.mat', 'model');
evaluate_model(model, 100);  % 100 Spiele
```

## Architektur

### Neural Network
- **Eingang**: 9 Werte (Brettzustand: 1 für X, -1 für O, 0 für leer)
- **Versteckte Schicht**: 64 Neuronen mit ReLU-Aktivierung
- **Ausgang**: 9 Werte (Wahrscheinlichkeiten für jeden möglichen Zug, Softmax)

### Zuggenerator

Der Zuggenerator implementiert Cleve Molers optimale Strategie:
1. Gewinne, wenn möglich
2. Blockiere den Gegner, wenn er gewinnen kann
3. Nimm das Zentrum, wenn verfügbar
4. Nimm eine Ecke, wenn verfügbar
5. Nimm eine Kante, wenn verfügbar
6. Zufälliger Zug (falls nichts anderes möglich)

## Trainingsdaten

Die Trainingsdaten werden generiert, indem:
- Viele Spiele mit dem optimalen Zuggenerator gespielt werden
- Jeder Brettzustand mit dem entsprechenden optimalen Zug gespeichert wird
- Das Netzwerk lernt, die optimalen Züge vorherzusagen

## Beispiel

```matlab
% Training
train_tictactoe_model

% Spielen
play_tictactoe

% Evaluierung
evaluate_model
```

## Referenzen

- Cleve Moler's Tic Tac Toe: https://www.mathworks.com/content/dam/mathworks/mathworksdot-com/moler/exm/chapters/tictactoe.pdf

## Lizenz

Dieses Projekt ist für Bildungszwecke erstellt.

