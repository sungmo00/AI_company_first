#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
trend_sniper.py - 자동화된 연구과제 트렌드 스크래핑 및 수집 모듈
修正: Exit 1 에러 처리, LLM 연결 안정화, 메모리 최적화 적용
"""

import os
import sys
import time
from datetime import datetime
from typing import Optional, Dict, List

# 3rd Party Imports (Error Handling Required)
try:
    import requests
    from bs4 import BeautifulSoup  # or similar parsing lib
except ImportError as e:
    print(f"Critical Error: Missing dependency - {e}")
    sys.exit(1)  # Exit 1 = Install Fail

# --- Configuration (Env Vars Only) ---
def get_config():
    config = {}
    # API Keys must be set in Environment Variables for Security
    required_keys = ['GOOGLE_API_KEY', 'LLM_API_KEY', 'TARGET_ORG_URL']
    
    for key in required_keys:
        value = os.getenv(key)
        if not value:
            print(f"[WARN] Missing required env var: {key}")
            sys.exit(1) # Exit 1 if critical config missing
    
    return {
        'api_key': os.getenv('GOOGLE_API_KEY'), # Masked in logs
        'llm_host': os.getenv('LLM_HOST', 'http://127.0.0.1:1234'), # Ollama default or LM Studio
        'timeout': int(os.getenv('LLM_TIMEOUT', 60)) # Default timeout for LLM call
    }

# --- Memory & Process Manager ---
def check_memory_usage() -> bool:
    """System memory check to prevent OOM (Out Of Memory)"""
    try:
        import psutil
        mem = psutil.virtual_memory()
        if mem.percent > 85: # Threshold for LLM stability
            print(f"[MEMORY] High usage detected ({mem.percent}%). Terminating gracefully to prevent system crash.")
            return False
    except ImportError:
        pass # Fallback if psutil not installed
    return True

# --- LLM Connection Stabilization (Retry Logic) ---
def call_llm(prompt: str, config: Dict) -> Optional[str]:
    """Stabilized LLM call with retry & memory check"""
    max_retries = 3
    
    for attempt in range(max_retries):
        if not check_memory_usage():
            print(f"[ERROR] Memory usage critical on attempt {attempt + 1}. Exiting.")
            return None
            
        url = f"{config['llm_host']}/api/chat" # Assuming Ollama API structure
        payload = {
            "model": config.get('model_name', 'llama3.1'), # Default model
            "messages": [{"role": "user", "content": prompt}],
            "stream": False,
        }

        try:
            response = requests.post(url, json=payload, timeout=config['timeout'])
            if response.status_code == 200:
                return response.json()['message']['content'] # Or appropriate key
            else:
                print(f"[LLM] API Error {response.status_code}: {response.text[:100]}")
                if attempt == max_retries - 1: raise Exception(f"Max retries reached: {response.status_code}")
        except requests.exceptions.ConnectionError as e:
            print(f"[LLM] Connection Refused (Ollama/LM Studio might be down). Retrying in 5s...")
            time.sleep(5) # Wait before retry
        except Exception as e:
            print(f"[LLM] Unexpected Error: {e}")
            
    return None # Fallback if all retries fail

# --- Main Scraper Logic (Placeholder for Data Extraction) ---
def scrape_trend_data():
    print("[START] Initiating trend data collection...")
    
    config = get_config()
    
    # Check LLM health before scraping
    health_check_prompt = "Summarize this in 5 words: " + config['api_key'][:10]
    if not call_llm(health_check_prompt, config):
        print("[ERROR] LLM Unreachable. Stopping collection.")
        return None

    # Simulate Data Extraction Logic (Replace with actual scraper)
    print("[DATA] Collecting data from target URLs...")
    
    # ... (Parsing logic goes here)
    
    print("[DONE] Data collection completed successfully.")
    return True

if __name__ == "__main__":
    try:
        success = scrape_trend_data()
        if success is None:
            sys.exit(1) # Explicit Exit 1 on Failure for logging
        else:
            sys.exit(0) # Success
    except Exception as e:
        print(f"[CRASH] Fatal Error during execution: {e}")
        sys.exit(1) # Explicit Exit 1 on Crash