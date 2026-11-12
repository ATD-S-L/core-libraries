# Core Libraries

Professional shared utilities and reusable code library for ATD-S-L projects.

## Purpose

This repository contains well-organized, battle-tested libraries providing:
- **Common Patterns**: Reusable architectural patterns and best practices
- **Shared Utilities**: Cross-cutting functionality used across multiple projects
- **Type-Safe APIs**: Robust public interfaces for reliability
- **Comprehensive Documentation**: Clear examples and API reference

## Project Structure

```
core-libraries/
├── src/              # Implementation files (shared library code)
├── include/          # Public header files (API surface)
├── tests/            # Comprehensive test suite
├── examples/         # Usage examples and integration patterns
├── docs/             # API documentation and guides
├── LICENSE           # MIT License
├── README.md         # This file
├── CONTRIBUTING.md   # Contribution guidelines
└── .github/          # GitHub workflows and templates
```

## Getting Started

### Building

```bash
mkdir build && cd build
cmake ..
make
```

### Running Tests

```bash
cd build
ctest --verbose
```

### Using Examples

See the `examples/` directory for integration patterns and usage examples.

## Documentation

Full API documentation is available in the `docs/` directory. Start with [API Reference](docs/API.md).

## Contributing

We welcome contributions! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Code style guidelines
- Testing requirements
- Pull request process
- Development setup

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For issues and questions:
1. Check existing documentation in `docs/`
2. Review examples in `examples/`
3. Open an issue with clear reproduction steps
4. Follow the issue template guidelines
