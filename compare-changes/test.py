import sys
import os
import importlib.util

# Dynamically import action.py as a module
script_dir = os.path.dirname(os.path.abspath(__file__))
action_path = os.path.join(script_dir, "action.py")
spec = importlib.util.spec_from_file_location("action", action_path)
action = importlib.util.module_from_spec(spec)
sys.modules["action"] = action
spec.loader.exec_module(action)


def test_check_for_matches():
    """Table-driven tests for pattern matching logic."""
    test_cases = [
        # pattern, changeset, expected_result
        {
            "patterns": ["*.yml"],
            "changes": ["foo.yml", "bar/test.yml"],
            "expected": True,
        },
        {
            "patterns": ["*.yml"],
            "changes": ["bar/test.yml"],
            "expected": False
        },
        {
            "patterns": ["**/*.yml"],
            "changes": ["foo.yml", "bar/test.yml"],
            "expected": True,
        },
        {
            "patterns": ["dir/**"],
            "changes": ["dir/file.txt", "dir/sub/file.txt"],
            "expected": True,
        },
        {
            "patterns": ["dir/**"],
            "changes": ["dir/sub/file.txt"],
            "expected": True,
        },
        {
            "patterns": ["dir/**/*"],
            "changes": ["dir/file.txt", "dir/sub/file.txt"],
            "expected": True,
        },
        {
            "patterns": ["dir/**/*"],
            "changes": ["dir/sub/file.txt"],
            "expected": True,
        },
        {
            "patterns": ["**/*.py"],
            "changes": ["main.py", "src/app.py", "docs/readme.md"],
            "expected": True,
        },
        {
            "patterns": ["**/*.py"],
            "changes": ["src/foo/app.py"],
            "expected": True,
        },
        {
            "patterns": ["*.md"],
            "changes": ["docs/readme.md"],
            "expected": False
        },
        {
            "patterns": ["*.md"],
            "changes": ["readme.md"],
            "expected": True
        },
        {
            "patterns": ["**/*.md"],
            "changes": ["docs/readme.md"],
            "expected": True
        },
        {
            "patterns": ["foo/bar.txt"],
            "changes": ["foo/bar.txt", "bar/foo.txt"],
            "expected": True,
        },
        {
            "patterns": ["foo/bar.txt"],
            "changes": ["bar/foo.txt"],
            "expected": False
        },
    ]
    for i, case in enumerate(test_cases):
        fnmatch_patterns = action.convert_github_patterns_to_fnmatch(case["patterns"])
        result = action.check_for_matches(
            case["patterns"], fnmatch_patterns, case["changes"]
        )
        print(
            f"Test case {i + 1}: patterns={case['patterns']} changes={case['changes']}\nExpected: {case['expected']} Got: {result}"
        )
        assert result == case["expected"], f"Failed test case {i + 1}"
    print("All tests passed.")


if __name__ == "__main__":
    test_check_for_matches()
