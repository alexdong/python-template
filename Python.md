# Python Coding Standards for AI Agents

## Core Philosophy

**We are a one-person army. Readability after a long hiatus is crucial.**

This core requirement sets the tone for all coding practices. Code must be understandable after not touching it for months or years. This requires simple, shorter code with clear data flow and state transitions that are easy to trace.

### Code Quality Checks (Sequential)

Automated checks catch issues early and maintain consistency. Running them in sequence prevents later tools from being confused by earlier failures.

- `uv run ruff format {files}`
- `uv run ruff check {files}`
- `uv run ty {files}`
- `uv run pytest -vv {files}_test.py` (minimum tests for changes)

### Test Facilities 
Full regression testing ensures changes don't break existing functionality. Coverage metrics indicate test quality.

- Single-module: `PYTHONPATH=$(pwd) uv run pytest -vv --cov=module_name --durations=4`
- Multi-module: `PYTHONPATH=$(pwd) uv run pytest -vv --cov=src --durations=4`

### Iterative Development Process

After you generate code, don't stop at the first pass. Instead, iteratively improve the generated code until you can't make it any better. Make it more readable, succinct. Focus on one particular enhancement each iteration. You must keep going until you can not find further ways to improve the code.

### Makefile Usage

Makefiles provide discoverable, consistent commands across projects. They reduce cognitive load by standardizing common tasks.

- Create Makefile entries for linting, testing, deployment
- Keep comments succinct and relevant
- Refactor repeated commands into Makefile targets

### Git Workflow

Frequent commits with clear messages provide better project history and easier debugging.

- Commit and push after completing each TODO item
- Include meaningful commit messages describing changes

## Development Environment

### Core Tools
- **Python**: 3.13+
- **Package Management**: `uv` (not pip or requirements.txt)
- **Typing**:
  - `pydantic` (more sophisticated types and data validation)
- **Code Quality**:
  - `ruff` (formatting and linting)
  - `ty` (type checking)
- **Logging**: `loguru`
- **Testing**: `pytest`
- **CLI Tools**: `click`, `prompt-toolkit`, `rich`
- **Web**: `fasthtml`
- **Templates**: `jinja2`
- **AI/LLM**: 
  - `pydantic-ai` (Agent and structured output and validation), 
  - OpenAI Whisper (audio)
- **Data & Analysis**: `numpy`, `plotly`, `streamlit`
- **Cross platform**: `platformdirs`
- **Hosting**: `cloudflare tunnel`

### System Environment
- **OS**: macOS 15.5+ or latest Ubuntu (both with complete dev toolchain installed)
- **Shell**: Latest zsh and oh-my-zsh
- **API Access**: Claude and OpenAI API keys via environment variables

### Rust CLI Tools
These tools provide superior performance and ergonomics for common development tasks:
- `curl` - HTTP client with better output formatting than system curl
- `jq` - JSON processor for parsing and manipulating JSON data
- `hyperfine` - Command-line benchmarking tool for performance testing

## Project Structure

```
./
├── docs/                   # Documentation and plans
├── {package_name}/         # Application code
│   ├── component/          # Component specific code and unit tests.
│   ├── utils/              # Component specific code and unit tests.
├── tests/
│   ├── integration/        # Integration tests
│   └── e2e/                # End-to-end tests
├── logs/                   # Implementation logs and progress tracking
├── .stubs/                 # Type stub files for 3rd party libraries
└── Makefile                # Task automation
└── pyproject.toml          # Project setting
```

## Coding Styles

### Readability and Naming

Code is read far more often than it's written. After months away from code, we need to understand it quickly without archaeological investigation.

#### Code Organization
- Put the top-level function at the top of each file (read top to bottom)
- Produce compact code - fewer lines mean less cognitive load
- Use non-`async` Python calls whenever possible
- Use one-liners (lambda, list comprehensions) to reduce line count
- Prefer simple code over clever hacks

#### Formatting and Spacing
- Use one empty line between key concept blocks within functions
- Use two empty lines between functions and classes
- Group related data and methods together in the same module
- Prefer composition over inheritance for code reuse

#### Naming Conventions
- Use descriptive variable names that explain the business logic
- Choose intention-revealing names that minimize effort to understand purpose
- Use searchable names: avoid single-letter variables outside small scopes (loops, comprehensions)
- Class names are nouns; function/method names are verbs
- Use descriptive constants instead of magic numbers: `RETRY_LIMIT = 3` not `3`
- Variable names should be pronounceable and specific to domain
- Hide internal data through proper encapsulation: private fields with `_` prefix

#### Strategic Commenting

- Comments explain intent and reasoning, not what code literally does
- Use `logger.debug`, not comment, to document what the code does
- Document business logic and domain-specific assumptions
- Use assert messages as inline documentation of contracts
- Comment complex algorithms that aren't obvious from implementation
- Explain "why" decisions were made, not "how" code works
- Skip comments for self-explanatory code with clear naming

#### Extract and Simplify
- Replace complex expressions with explanatory variables
- Move closely related statements into dedicated functions
- When classes become too large, extract focused classes with single responsibilities
- Group related data and behavior together in the same module

#### __main__ Block Requirements

Every Python file should be executable for testing and demonstration. This enables quick verification of functionality.

- Include `if __name__ == "__main__"` block in every script
- Use `__main__` function to demonstrate usage and test code
- Enable direct CLI invocation of functions within files

### Function Design

Functions are the primary building blocks for readable, testable code. 
Clear function design reduces cognitive load and enables better composition.

#### Principles

- Prefer functions over classes for most use cases
- Keep functions small (typically under 20 lines with McCabe complexity under 6)
- Functions should do one thing and do it well
- Return structured `@dataclass` or `namedtuple` instead of tuples for readability
- Follow Command-Query Separation: separate functions that change state from those that return data
- Write docstrings only when function intention is unclear from name/implementation


#### Fail Early and Fast

Debugging issues discovered late in execution is exponentially more expensive than catching them early. 
Clear failure points reduce investigation time.

- Prefer `assert` over `Optional` or try/except for clearer intent
- Avoid `try` and `except`. Use `assert` instead
- Use generous `assert` statements to check data integrity, program flow so we can fail fast
- Make sure use descriptive assert messages to document states

#### Control Flow Patterns

Clear control flow reduces cognitive load and makes code easier to follow. 
Minimize nesting and make decision paths explicit.

- Use guard clauses to handle edge cases early and reduce nesting
- When appropriate, use `assert` at the beginning and end of each function to enforce design contracts
- Return early from functions to avoid deep indentation
- Handle invalid states at the beginning of functions
- Extract complex boolean expressions into well-named variables
- Break down compound conditionals for clarity

#### Traceability, Logging and Debuggability

When code fails (and it will), we need to quickly understand what happened and where. 
Logs are our time machine for understanding past execution.

- Use `from loguru import logger` instead of the default logging framework. 
- Use `logger.debug` to document the code and execution flow. 
- Prefer logging over code comments.
- By default, output the log to path using `platformdirs`: `PlatformDirs().site_log_dir` 
- Always turn on `logger.add(..., backtrace=True, diagnose=True)`
- Use log message format: `format="{time:MMMM D, YYYY > HH:mm:ss!UTC} | {level} | {message} | {extra}")`
- Use loguru's `bind()` and `contextualize()` to include extra information at log point.
- When debugging, use `--debug-modules module1,module2` for selective debug logging


### Use Modern Python Features

Leverage modern Python features for concise, expressive code that takes advantage of the latest language improvements.

#### Pythonic Idioms and Expressions
- Use dictionary comprehensions with conditions: `{k: v for k, v in items.items() if v > threshold}`
- Prefer `enumerate()` over manual indexing: `for i, item in enumerate(items)` not `for i in range(len(items))`
- Use `zip()` for parallel iteration: `for name, score in zip(names, scores)`
- Leverage walrus operator for assignment expressions: `if (n := len(data)) > 10:`
- Use `dict.get()` with defaults: `counts.get(key, 0)` instead of `if key in counts`
- Prefer `dict |= other` over `dict.update(other)` for merging

#### Function Design Patterns
- Use keyword-only arguments for clarity: `def process(data, *, debug=False, timeout=30):`
- Leverage `functools.partial()` for function specialization: `debug_log = partial(log, level='DEBUG')`
- Use `functools.cache` for memoization: `@cache` decorator for pure functions
- Prefer generator expressions over list comprehensions for large datasets: `sum(x**2 for x in range(1000000))`
- Use `yield from` for generator delegation: `yield from other_generator()`

#### Data Model and Collections
- Implement `__slots__` for memory efficiency in data classes: `__slots__ = ('x', 'y', 'z')`
- Use `collections.defaultdict` instead of manual key checking: `defaultdict(list)`
- Leverage `itertools` for efficient iteration: `itertools.chain()`, `itertools.groupby()`
- Use `operator` module for functional operations: `operator.attrgetter('name')` instead of lambdas
- Prefer `frozenset()` for immutable collections when hashability needed

#### Modern Syntax Features
- Use `match` for complex conditionals instead of if/elif chains:
- Use `match` with data structures for destructuring:
- Leverage f-string improvements: `f"{value=}"` for debugging, `f"{value:.2%}"` for formatting  
- Use positional-only parameters: `def func(pos_only, /, pos_or_kw, *, kw_only):`
- Apply union type syntax: `str | int | None` instead of `Union[str, int, None]`
- Use generic type syntax: `list[str]` instead of `List[str]`

#### Control Flow and Context Management
- Implement custom context managers with `contextlib.contextmanager`: `@contextmanager`
- Use `contextlib.suppress()` for ignoring specific exceptions: `with suppress(FileNotFoundError):`
- Leverage `itertools.takewhile()` and `itertools.dropwhile()` for conditional iteration
- Use generator functions for lazy evaluation: `def fibonacci(): ...` with `yield`
- Prefer `pathlib.Path` over string manipulation for file operations

### Database Strategy

- Use SQLite for data persistence if possible. Use postgresql in production.
- Use separate SQLite files for different environments: dev, staging, main.
- Use in-memory SQLite (`sqlite:///:memory:`) for testing. Use `conftest.py` for test database setup
- Always output SQL in logs to help with debugging. Avoid ORMs.
- Name an entity `class Entity` and the associated database access code as `class EntityDB`


### Test Organization and Quality

#### Test Structure and Naming
- Name test files `{feature}_test.py` and put them in the same folder as `{feature}.py`
- Use descriptive test names that explain what is being tested
- Prefer functions recognizable by `pytest` over test classes
- Tests should be independent of each other - avoid shared state
- Use `fixture` selectively to avoid copy-paste duplicated code in test
- Keep test logic simple: avoid loops, complex conditionals in tests

#### Test Implementation
- Use plain `assert` statements for clarity
- Make sure the assert statements capture intent and contracts
- Tests should be fast: avoid sleep, use mocks for external dependencies
- Set the log level to DEBUG in tests to gather additional runtime details
- Use `@pytest.mark.parametrize` to separate code from test data
- Use `@pytest.mark.{category}` and `@pytest.mark.requirement({FeatureName})` for test categorization
- Use `pytest.approx` with two decimal points for float/decimal comparisons
- Use `pytest`'s `--durations=4` to identify and optimise away any unit tests that takes longer than 0.01s to complete.