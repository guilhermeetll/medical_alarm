#!/usr/bin/env python3
"""
Simple test script to verify the API is working correctly.
"""

import requests
import json
import sys

BASE_URL = "http://localhost:8000"


def test_health_check():
    """Test if the API is running."""
    try:
        response = requests.get(f"{BASE_URL}/health")
        if response.status_code == 200:
            print("✅ Health check passed")
            return True
        else:
            print(f"❌ Health check failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Health check failed: {e}")
        return False


def test_root_endpoint():
    """Test the root endpoint."""
    try:
        response = requests.get(BASE_URL)
        if response.status_code == 200:
            print("✅ Root endpoint accessible")
            return True
        else:
            print(f"❌ Root endpoint failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Root endpoint failed: {e}")
        return False


def test_docs_accessible():
    """Test if API documentation is accessible."""
    try:
        response = requests.get(f"{BASE_URL}/docs")
        if response.status_code == 200:
            print("✅ Swagger UI accessible")
            return True
        else:
            print(f"❌ Swagger UI failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Swagger UI failed: {e}")
        return False


def main():
    """Run all tests."""
    print("Testing Alarm Care Pro API...")
    print("=" * 40)
    
    tests = [
        test_health_check,
        test_root_endpoint,
        test_docs_accessible,
    ]
    
    passed = 0
    total = len(tests)
    
    for test in tests:
        if test():
            passed += 1
    
    print("=" * 40)
    print(f"Tests passed: {passed}/{total}")
    
    if passed == total:
        print("🎉 All tests passed! API is ready to use.")
        print("\nYou can now:")
        print("- Visit http://localhost:8000/docs for interactive API documentation")
        print("- Visit http://localhost:8000/redoc for alternative documentation")
    else:
        print("⚠️  Some tests failed. Check if the API is running.")
        sys.exit(1)


if __name__ == "__main__":
    main()
