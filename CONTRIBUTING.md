# Contributing to Core Libraries

Thank you for your interest in contributing to core-libraries! This document provides guidelines and instructions for contributing.

## Code of Conduct

Be respectful, inclusive, and constructive in all interactions.

## Getting Started

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Follow the project structure and conventions
4. Commit with clear, descriptive messages
5. Push to your fork and open a pull request

## Development Setup

```bash
# Clone and setup
git clone https://github.com/ATD-S-L/core-libraries.git
cd core-libraries
mkdir build && cd build
cmake ..
make

# Run tests
ctest --verbose
```

## Code Style

- **Naming**: Use clear, descriptive names (snake_case for functions, PascalCase for classes)
- **Comments**: Document complex logic; keep comments accurate and up-to-date
- **Formatting**: Follow project conventions consistently
- **Headers**: Public interfaces in `include/`, implementation in `src/`

## Testing Requirements

- Write tests for all new functionality
- Ensure all tests pass: `ctest --verbose`
- Aim for meaningful test coverage
- Test both happy paths and edge cases

## Pull Request Process

1. Update documentation if needed
2. Add tests for new features or bug fixes
3. Ensure all tests pass locally
4. Keep commits focused and logically separated
5. Write clear PR descriptions explaining changes
6. Link related issues

## Submitting Issues

When reporting bugs or requesting features:
- Use the issue template provided
- Include reproduction steps for bugs
- Provide context and expected behavior
- Add relevant labels and milestones

## Documentation

- Update `docs/` for API changes
- Add examples in `examples/` for new features
- Keep README.md current
- Document all public interfaces

## Questions?

Feel free to open an issue or discussion for questions about contributing.

Thank you for helping improve core-libraries!
