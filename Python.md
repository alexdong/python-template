# Python Coding Standards for AI Agents

## Development Environment

### Core Tools

- **Python**: 3.13+
- **Package Management**: `uv` (not pip or requirements.txt)
- **Typing**: `pydantic` (types and validation)
- **Code Quality**: `ruff` (formatting and linting), `ty` (type checking)
- **Logging**: `loguru`
- **Testing**: `pytest`
- **CLI Tools**: `click`, `typer`, `prompt-toolkit`, `rich` and `shellingham`
- **Web**: `fasthtml`
- **Templates**: `jinja2`
- **AI/LLM**: use anthropic by default using `pydantic-ai`
- **Data & Analysis**: `numpy`, `plotly`, `streamlit`
- **Cross platform**: `platformdirs`
- **Hosting**: `cloudflare tunnel`

### System Requirements

- **OS**: macOS 15.5+ or latest Ubuntu with dev tools
- **Shell**: zsh with oh-my-zsh
- **API Keys**: Claude and OpenAI (environment variables)

### Rust CLI Tools

- `curl` - Enhanced HTTP client
- `jq` - JSON processor

## Project Structure

```
./
├── .claude/                # Claude Code slash commands
├── docs/                   # Documentation
├── {package_name}/         # Application code
│   ├── cli/                # CLI related code
│   ├── component/          # Component code and tests
│   ├── db/                 # Database access code and tests
│   ├── models/             # Entities and models
│   └── utils/              # Utility code and tests
│   └── web/                # Web code
├── tests/
│   ├── integration/        # Integration tests
│   └── e2e/                # End-to-end tests
├── Makefile                # Task automation
└── pyproject.toml          # Project configuration
```

## Readability and Naming

### Code Organization

- [CO1] Place the most important functions at file top
- [CO2] Write compact code (fewer lines, less cognitive load)
- [CO3] Choose simplicity over cleverness
- [CO4] Use one-liners for simple operations

### Formatting and Spacing

- [FS1] One empty line between concept blocks within functions
- [FS2] Two empty lines between functions and classes
- [FS3] Group related data and methods in same module
- [FS4] Prefer composition over inheritance

### Naming Conventions

- [NC1] Use descriptive variable names that explain business logic
- [NC2] Make names reveal intent
- [NC3] Avoid single-letter variables except in loops
- [NC4] Classes: nouns; functions: verbs
- [NC5] Replace magic numbers with named constants: `RETRY_LIMIT = 3`
- [NC6] Use pronounceable, domain-specific names
- [NC7] Mark private fields with `_` prefix

### Comments

- [CM1] Explain intent and reasoning, never what code does
- [CM2] Use `logger.debug` to document execution flow
- [CM3] Document business logic and domain assumptions
- [CM4] Use assert messages to enforce contracts
- [CM5] Comment non-obvious algorithms
- [CM6] Omit comments for self-explanatory code

### Extract and Simplify

- [ES1] Replace complex expressions with explanatory variables
- [ES2] Move related statements into dedicated functions
- [ES3] Extract focused functions or classes from large ones
- [ES4] Group related data and behavior in same module

### __main__ Block Requirements

Every Python file must be executable:

- [MB1] Add `if __name__ == "__main__":` block
- [MB2] Demonstrate file's primary purpose
- [MB3] Enable direct execution and testing
- [MB4] Call `main()` function from block to keep global namespace clean
- [MB5] Use `click` for command-line interfaces

### Function Design

Functions are the primary building blocks. Design them for clarity and composition.

### Principles

- [FP1] Prefer functions over classes
- [FP2] Keep functions simple (McCabe complexity under 6)
- [FP3] Do one thing well
- [FP4] Return structured data (`@dataclass`, `namedtuple`, `enum`) instead of tuples, mixed typed lists or dicts
- [FP5] Separate state-changing functions from data-returning functions
- [FP6] Write docstrings only when intent is unclear

### Fail Early and Fast

Catch problems immediately:

- [FE1] Use `assert` instead of `Optional` or try/except
- [FE2] Avoid `try`/`except`; use `assert`
- [FE3] Add generous `assert` statements for data integrity
- [FE4] Write descriptive assert messages

### Control Flow

Minimize nesting and make paths explicit:

- [CF1] Use guard clauses for edge cases
- [CF2] Add `assert` statements at function boundaries
- [CF3] Return early to avoid deep indentation
- [CF4] Handle invalid states first
- [CF5] Extract complex boolean expressions into named variables
- [CF6] Break down compound conditionals

### Logging

Logs are your debugging time machine:

- [LG1] Use `from loguru import logger`
- [LG2] Use `logger.debug` for execution flow documentation
- [LG3] Prefer logging over comments
- [LG4] Log to `PlatformDirs().site_log_dir`
- [LG5] Enable `logger.add(..., backtrace=True, diagnose=True)`
- [LG6] Format: `"{time:MMMM D, YYYY > HH:mm:ss!UTC} | {level} | {message} | {extra}"`
- [LG7] Use `bind()` and `contextualize()` for context
- [LG8] Debug selectively: `--debug-modules module1,module2`

### Modern Python Features

### Pythonic Idioms

- [PI1] Dictionary comprehensions: `{k: v for k, v in items.items() if v > threshold}`
- [PI2] Use `enumerate()`: `for i, item in enumerate(items)`
- [PI3] Use `zip()`: `for name, score in zip(names, scores)`
- [PI4] Walrus operator: `if (n := len(data)) > 10:`
- [PI5] Dictionary defaults: `counts.get(key, 0)`
- [PI6] Dictionary merging: `dict |= other`

### Function Patterns

- [FN1] Keyword-only arguments: `def process(data, *, debug=False, timeout=30):`
- [FN2] Function specialization: `debug_log = partial(log, level='DEBUG')`
- [FN3] Memoization: `@cache` decorator for pure functions
- [FN4] Generator expressions: `sum(x**2 for x in range(1000000))`
- [FN5] Generator delegation: `yield from other_generator()`

### Data Model and Collections

- [DM1] Memory efficiency: `__slots__ = ('x', 'y', 'z')`
- [DM2] Default dictionaries: `defaultdict(list)`
- [DM3] Efficient iteration: `itertools.chain()`, `itertools.groupby()`
- [DM4] Functional operations: `operator.attrgetter('name')`
- [DM5] Immutable collections: `frozenset()`

### Modern Syntax

- [MS1] Pattern matching: `match` for complex conditionals and destructuring
- [MS2] F-string debugging: `f"{value=}"` and formatting: `f"{value:.2%}"`
- [MS3] Parameter constraints: `def func(pos_only, /, pos_or_kw, *, kw_only):`
- [MS4] Union syntax: `str | int | None`
- [MS5] Generic syntax: `list[str]`

### Context Management

- [CT1] Custom context managers: `@contextmanager`
- [CT2] Exception suppression: `with suppress(FileNotFoundError):`
- [CT3] Conditional iteration: `itertools.takewhile()`, `itertools.dropwhile()`
- [CT4] Lazy evaluation: generator functions with `yield`
- [CT5] Path operations: `pathlib.Path`

### Database Strategy

- [DB1] SQLite for development, PostgreSQL for production
- [DB2] Separate databases per environment: dev, staging, main
- [DB3] In-memory SQLite for tests (`sqlite:///:memory:`)
- [DB4] Log all SQL queries for debugging
- [DB5] Avoid ORMs
- [DB6] Naming: `models/{entity}.py: class Entity` and `db/{entity}.py: class EntityDB`

### Testing

### Structure and Naming

- [TS1] Name test files `{feature}_test.py` alongside `{feature}.py`
- [TS2] Use descriptive test names
- [TS3] Prefer test functions over test classes
- [TS4] Make tests independent (no shared state)
- [TS5] Use fixtures to reduce duplication
- [TS6] Keep test logic simple (no loops or complex conditionals)

### Implementation

- [TI1] Use plain `assert` statements
- [TI2] Write assert messages that capture intent
- [TI3] Make tests fast (no sleep, mock external dependencies)
- [TI4] Set log level to DEBUG in tests
- [TI5] Use `@pytest.mark.parametrize` for test data
- [TI6] Use `@pytest.mark.{category}` for categorization
- [TI7] Use `pytest.approx` for float comparisons
- [TI8] All tests should finish executing under 10ms. Use `durations` to find slow tests
