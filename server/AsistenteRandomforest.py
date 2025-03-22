import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
import joblib  # Para guardar el modelo

# 1. Cargar el Dataset
archivo_csv = "./server/enfermedades_hemoparasitarias.csv"
df = pd.read_csv(archivo_csv)

# 2. Separar Características (X) y Etiqueta (y)
X = df.drop(columns=["Resultado"])
y = df["Resultado"]

# 3. Codificar la Etiqueta
label_encoder = LabelEncoder()
y_encoded = label_encoder.fit_transform(y)

# 4. Dividir el Dataset
X_train, X_test, y_train, y_test = train_test_split(X, y_encoded, test_size=0.2, random_state=42)

# 5. Crear y Entrenar el Modelo Random Forest
random_forest = RandomForestClassifier(n_estimators=1000, random_state=42)
random_forest.fit(X_train, y_train)

# 6. Evaluar el Modelo
y_pred = random_forest.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f"Precisión del Modelo Random Forest: {accuracy * 100:.2f}%")

# Reporte de Clasificación
print("Reporte de Clasificación:")
print(classification_report(y_test, y_pred, target_names=label_encoder.classes_))

# 7. Guardar el Modelo y el Codificador
joblib.dump(random_forest, "modelo_random_forest.pkl")
joblib.dump(label_encoder, "label_encoder.pkl")
print("Modelo y codificador guardados exitosamente.")
