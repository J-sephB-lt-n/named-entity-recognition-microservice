"""The entrypoint of the Flask app"""

from typing import Final

import flask
from gliner import GLiNER

app = flask.Flask(__name__)

HIGH_CONFIDENCE_THRESHOLD: Final[float] = 0.3

LABELS: Final[list[str]] = [
    "company industry",
    "company location",
    "employee role(s)",
    "website keyword",
    "employee count",
]

ner_model = GLiNER.from_pretrained("urchade/gliner_medium-v2.1")
# ner_model = GLiNER.from_pretrained("urchade/gliner_large-v2.1")


@app.route("/", methods=["GET"])
def root():
    """Extracts named entities from a natural language user query"""
    user_query: str = flask.request.args["query"]
    results: dict = {
        "high_confidence": {label: [] for label in LABELS},
        "low_confidence": {label: [] for label in LABELS},
    }
    predicted_entities = ner_model.predict_entities(user_query, LABELS, threshold=0.1)

    for entity in predicted_entities:
        if entity["score"] < HIGH_CONFIDENCE_THRESHOLD:
            confidence_bucket = "low_confidence"
        else:
            confidence_bucket = "high_confidence"
        results[confidence_bucket][entity["label"]].append(
            f'{entity["text"]} ({entity["score"]:.2f})'
        )

    return flask.jsonify(results)
