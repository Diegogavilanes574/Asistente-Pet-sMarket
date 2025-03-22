import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, accuracy_score
from sklearn.preprocessing import LabelEncoder
import joblib
import logging
from tqdm import tqdm

# Configuración del logger
logging.basicConfig(filename='entrenamiento_modelo.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)
logger.info("Inicio del script de entrenamiento.")

# 1. Cargar el dataset
try:
    data = pd.read_csv("enfermedades_hemoparasitarias.csv")  # Usa el nombre real de tu archivo
    logger.info("Dataset cargado correctamente.")
except FileNotFoundError:
    logger.error("Error: Archivo no encontrado. Verifica la ruta.")
    exit()
except pd.errors.EmptyDataError:
    logger.error("Error: El archivo está vacío.")
    exit()
except pd.errors.ParserError:
    logger.error("Error: No se pudo analizar el archivo. Verifica el formato (CSV).")
    exit()

# 2. Preprocesamiento de datos
le = LabelEncoder()
data['Resultado'] = le.fit_transform(data['Resultado'])
logger.info("Columna 'Resultado' convertida a numérica.")

# 3. Separar características y variable objetivo
X = data.drop("Resultado", axis=1)
y = data["Resultado"]

# 4. Dividir los datos
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
logger.info("Datos divididos en entrenamiento y prueba.")

# 5. Entrenar el modelo con tqdm (simulando progreso)
n_estimators = 100
model = RandomForestClassifier(n_estimators=n_estimators, random_state=42, n_jobs=-1)
logger.info(f"Entrenando modelo RandomForest con {n_estimators} estimadores.")

try:
    for i in tqdm(range(n_estimators), desc="Entrenando árboles"):
        #Entrenar un solo arbol cada vez
        model_temp = RandomForestClassifier(n_estimators=1, max_features='sqrt', random_state=i, max_depth=None, min_samples_split=2, min_samples_leaf=1, bootstrap=False)
        #Entrenar solo con una muestra de los datos para simular el entrenamiento incremental y que tarde algo
        X_train_temp, _, y_train_temp, _ = train_test_split(X_train, y_train, test_size=0.95, random_state=i)

        model_temp.fit(X_train_temp, y_train_temp)
        if i==0:
            model.estimators_ = model_temp.estimators_
        else:
            model.estimators_.extend(model_temp.estimators_)

except ValueError as e:
    logger.error(f"Error durante el entrenamiento: {e}")
    exit()

logger.info("Entrenamiento del modelo completado.")

# 6. Predicciones
y_pred = model.predict(X_test)

# 7. Evaluación
report = classification_report(y_test, y_pred, target_names=le.inverse_transform(model.classes_))
accuracy = accuracy_score(y_test, y_pred)
logger.info(f"Informe de Clasificación:\n{report}")
logger.info(f"Precisión del modelo: {accuracy}")
print("Informe de Clasificación:\n", report)
print("Precisión del modelo:", accuracy)

# 8. Guardar el modelo y el LabelEncoder
joblib.dump(model, 'modelo_enfermedades.pkl')
joblib.dump(le, 'label_encoder.pkl')
logger.info("Modelo y LabelEncoder guardados.")
print("Modelo y LabelEncoder guardados.")

logger.info("Fin del script de entrenamiento.")
