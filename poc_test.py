#!/usr/bin/env python3
"""AutoPoC Test Script for sisyphus-academica (CLI/Job-based testing)."""
import json, os, subprocess, sys, time

NAMESPACE = os.environ.get("POC_NAMESPACE", "poc-sisyphus-academica")
results = []

def run_job_test(scenario_name, job_name, expected_content=None, timeout=120):
    start = time.time()
    try:
        status_cmd = ["kubectl", "get", "job", job_name, "-n", NAMESPACE, "-o", "jsonpath={.status.succeeded}"]
        status_result = subprocess.run(status_cmd, capture_output=True, text=True, timeout=30)
        succeeded = status_result.stdout.strip()
        logs_cmd = ["kubectl", "logs", f"job/{job_name}", "-n", NAMESPACE]
        logs_result = subprocess.run(logs_cmd, capture_output=True, text=True, timeout=30)
        output = logs_result.stdout[:2000]
        if succeeded == "1":
            if expected_content and expected_content not in output:
                r = {"scenario_name": scenario_name, "status": "fail", "output": output,
                     "error_message": f"Expected '{expected_content}' not in output",
                     "duration_seconds": round(time.time() - start, 2)}
            else:
                r = {"scenario_name": scenario_name, "status": "pass", "output": output,
                     "error_message": None, "duration_seconds": round(time.time() - start, 2)}
        else:
            r = {"scenario_name": scenario_name, "status": "fail", "output": output,
                 "error_message": f"Job did not succeed", "duration_seconds": round(time.time() - start, 2)}
    except Exception as e:
        r = {"scenario_name": scenario_name, "status": "error", "output": "",
             "error_message": str(e), "duration_seconds": round(time.time() - start, 2)}
    results.append(r)
    return r

run_job_test("cli-help", "sisyphus-help", expected_content="academica")
run_job_test("demo-run", "sisyphus-demo", expected_content="Demo complete")
run_job_test("module-import", "sisyphus-import", expected_content="Core tools loaded")

print(json.dumps({"results": results}, indent=2))
sys.exit(1 if any(r["status"] in ("fail", "error") for r in results) else 0)
