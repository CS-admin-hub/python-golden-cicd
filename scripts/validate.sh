#!/bin/bash
# Validation script to test the entire setup locally

set -e

echo "🔍 Validating golden-cicd-python setup..."
echo ""

# Check if required files exist
echo "✓ Checking required files..."
required_files=(
    "app/main.py"
    "tests/test_main.py"
    "Dockerfile"
    "requirements.txt"
    ".github/workflows/ci-cd.yml"
    "scripts/deploy.sh"
    ".env.example"
    "README.md"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file (missing)"
        exit 1
    fi
done

echo ""
echo "✓ All required files present"
echo ""

# Validate YAML syntax
echo "🔍 Validating GitHub Actions workflow..."
if command -v yamllint &> /dev/null; then
    yamllint .github/workflows/ci-cd.yml && echo "  ✓ YAML syntax valid"
else
    echo "  ⚠ yamllint not installed, skipping YAML validation"
fi

echo ""
echo "✅ Validation complete!"
echo ""
echo "Next steps:"
echo "1. Create GitHub repository: https://github.com/new"
echo "2. Push code: git push -u origin main"
echo "3. Check Actions tab for pipeline status"
