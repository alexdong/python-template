.PHONY: dev test test-coverage type-coverage update-llms-txt

dev:
	uv run ruff check . --fix --unsafe-fixes
	uv run ruff format .
	uv run ty check .

test:
	pytest --lf

test-coverage:
	pytest --cov=. --cov-report=html --cov-report=term --duration=5 

type-coverage:
	@echo "🔍 Checking type annotation coverage..."
	@echo "📊 Checking for missing return type annotations..."
	@uv run ruff check . --select ANN201 --quiet || echo "❌ Missing return type annotations found"
	@echo "📊 Checking for missing parameter type annotations..."
	@uv run ruff check . --select ANN001,ANN002,ANN003 --quiet || echo "❌ Missing parameter type annotations found"
	@echo "📊 Running comprehensive type check..."
	@uv run ty check . > /dev/null 2>&1 && echo "✅ Type checking passed - excellent coverage!" || echo "❌ Type checking failed"
	@echo "📊 Checking for Any usage (should be minimal)..."
	@uv run ruff check . --select ANN401 --quiet && echo "✅ No problematic Any usage found" || echo "⚠️  Some Any usage found (may be acceptable in tests)"
	@echo "📈 Type coverage assessment complete!"

update-llms-txt:
	@echo "📚 Updating llms/*.txt documentation files..."
	@mkdir -p llms
	@claude -p "can you create a ./llms directory and produce llms/{tools}.txt files for each tool mentioned in Python.md directory. For CLI tools, produce it through saving the \`--help\` and potential \`tldr\` example output; For python packages, search the website for \`llms.txt\` or \`llms-full.txt\`. For example, you can find https://docs.pydantic.dev/latest/llms-full.txt for pydantic. Lastly, always document how the output is retrieved at the bottom of each document so future operations can be automated. can you also add a \`claude -p\` statement in Makefile that's \`make update-llms-txt\` which will automatically update all the llms/.txt files. (You can use this prompt as a template.)"
	@echo "✅ llms/*.txt files updated!"
