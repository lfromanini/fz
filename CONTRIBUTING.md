# fz

fz - Pipe commands to FZF

## Contributing

Contributions are welcome. Please follow the conventions below when adding or modifying commands.

### Code Structure

- `fz::*` functions are public commands. Every `fz::*` function must correspond to a command that can be invoked as `fz <command>`.
- Public commands are automatically discovered by `__fz::commands`. They are therefore automatically included in `--help` and shell completions.
- `__fz::*` functions are private support functions and are not exposed as commands.
- If a private function is only used by a single command, define it inside that command's function. Follow the existing pattern in `fz::kill`.
- Add a `__fz::help::*` function for every `fz::*` command. Help functions are automatically discovered and included in `--help`.
- Keep `fz::*` command functions in alphabetical order.
- Keep `__fz::*` support functions in alphabetical order within their respective sections.

### Code Style

- Use the existing indentation, spacing and formatting conventions.
- Keep generated help output aligned with the existing format.
- Keep Bash compatibility in mind and avoid newer Bash-specific features when a portable alternative is available.

### Optional Commands

Commands that depend on optional programs must only be defined when the required program is available.

For example, the `tmux` command is defined only when `tmux` is installed:

```bash
command -v tmux &>/dev/null && function fz::tmux()
```

Optional commands must be tested both when their dependency is installed and when it is unavailable.

### Completions

When adding or removing commands, make sure both Bash and Zsh completions continue to work. Command lists are generated automatically; do not duplicate command names manually in completion definitions.

### Help

When adding or modifying help text, preserve the existing indentation and formatting. The source uses tabs for indentation, while spaces are used where they are part of the generated help output. Keep heredocs aligned with the existing code.

Before submitting a change, verify the output with:

```bash
fz --help
```

### ShellCheck

Run [ShellCheck](https://www.shellcheck.net/) on the shell scripts before submitting a change.

```bash
shellcheck bin/fz tests/*.bats tests/mocks/* tests/support/*.bash
```

Existing ShellCheck warnings should only be disabled when there is a specific reason, and the reason should be documented in the comment.

### Tests

Tests are written using [Bats-core: Bash Automated Testing System](https://github.com/bats-core/bats-core).

Run the test suite before submitting a change:

```bash
bats tests/
```

When adding or modifying a command, add or update the corresponding tests. Test cancellation (`ESC`), error cases and optional dependencies where applicable.
