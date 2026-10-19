# fz

fz - Pipe commands to FZF

## Contributing

Contributions are welcome. Please follow the conventions below when adding or modifying commands.

### Code Structure

- `fz::*` functions are public commands. Every `fz::*` function must correspond to a command that can be invoked as `fz <command>`.
- Add a `__fz::<command>::fz::help` function for every `fz::<command>` command. Help functions are automatically discovered and included in `--help`.
- Public commands are automatically discovered by `__fz:core::commands`. They are therefore automatically included in `--help` and shell completions.
- `_fz::*` functions are internal functions intended to be called by developers. Since FZF starts a new shell for previews, you may need to call an internal function via `fz _fz::<command>::<function>`.
- `__fz::*` functions are private support functions and are not exposed as commands.
- Keep `fz::*` command functions in alphabetical order.
- Keep `__fz::*` support functions in alphabetical order within their respective scope.

### Code Style

- Use the existing indentation, spacing and formatting conventions.
- Keep generated help output aligned with the existing format.
- Keep Bash compatibility in mind and avoid newer Bash-specific features when a portable alternative is available.

### Optional Commands

Commands that depend on optional programs must only be defined when the required program is available.

For example, the `tmux` command is defined only when `tmux` is installed:

```bash
command -v tmux &>/dev/null && function fz::tmux()
{
	...
}

command -v tmux &>/dev/null && function __fz::tmux::fz::help()
{
	...
}
```

Optional commands must be tested both when their dependency is installed and when it is unavailable.

### Internal API

The following functions provide common utilities for internal `fz` functions.

- `__fz:api::command [COMMAND ...]`

  Resolves the first available command from the given list and prints its resolved value to standard output. Before resolving each candidate, it removes any alias or shell function with the same name to ensure that `command -v` does not resolve to either of them. Candidates are checked in order, and the search stops at the first successful match. If no command is found, an empty line is printed.

- `__fz:api::confirm [MESSAGE]`

  Prompts the user to confirm an action using `fzf`, presenting `Yes` and `No` options. `MESSAGE` is displayed as the prompt header and defaults to `Proceed?` when omitted. The calling function's name is used as the prompt prefix.

  Returns success if the user selects `Yes`, and failure otherwise.

- `__fz:api::fzf [ARG ...]`

  Wraps `fzf`, forwarding all arguments and treating exit status `130` (cancellation) as success. This prevents user cancellation from triggering `pipefail` in calling pipelines.

### Completions

When adding or removing commands, make sure both Bash and Zsh completions continue to work.

The top-level command list is generated automatically from the available public `fz::*` functions. Do not duplicate command names manually in completion definitions.

Commands may also provide their own completions for arguments and subcommands by defining a completion function in their private namespace:

```bash
function __fz::<command>::fz::completion()
{
	...
}
```

The completion function is associated with the corresponding command by its name:

```text
fz::<command>
    |
    +-- __fz::<command>::fz::completion
```

This allows commands to provide argument or subcommand completions without requiring changes to the global completion implementation. For example, `__fz::kill::fz::completion` provides completions for `fz::kill`.

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
bats --verbose-run tests/
```

When adding or modifying a command, add or update the corresponding tests. Test cancellation (`ESC`), error cases and optional dependencies where applicable.
