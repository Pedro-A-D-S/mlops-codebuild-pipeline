import pytest
from serving.app import ModelInferenceEngine

@pytest.fixture
def engine():
    return ModelInferenceEngine()

def test_health_check(engine):
    res = engine.health()
    assert res["status"] == "HEALTHY"
    assert "fargate" in res["model_version"]

def test_prediction_valid(engine):
    features = [0.12, 0.45, 0.88, 0.23, 0.99]
    res = engine.predict("ACC-12345", features)
    assert res["account_id"] == "ACC-12345"
    assert "prediction_score" in res
    assert res["decision"] in ["APPROVE", "DECLINE"]
    assert res["latency_ms"] >= 0.0

def test_prediction_invalid_features(engine):
    with pytest.raises(ValueError, match="at least 4 numerical features"):
        engine.predict("ACC-ERR", [0.1])
