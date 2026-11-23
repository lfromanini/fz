# fz

fz - Pipe commands to FZF

## Contributing

Contributions are welcome. Please follow the conventions below when adding or modifying commands.

### Code Structure

- `fz::*` functions are commands wrappers. Every `fz::*` function must correspond to a command that can be invoked as `fz <command>`.
- Add a `public:fz::<command>::fz::help` function for every `fz::<command>` command. Help functions are automatically discovered and included in `--help`.
- Commands are automatically discovered by `fz:core::commands`. They are therefore automatically included in `--help` and shell completions.
- `public:fz::*` functions are public exposed functions intended to be called by developers. Since FZF starts a new shell for previews, you may need to call some functions via `fz public:fz::<command>::<function>`.
- Keep functions in alphabetical order and within their respective scope.

### Hooks

Commands can define optional lifecycle hooks that are automatically invoked by the core.

Hooks must be defined in the command's private namespace using the following naming convention:

```bash
function fz::<command>::fz::hook::<hook>()
{
	...
}
```

The following hooks are currently supported:

| Hook      | Description                                                        |
|-----------|--------------------------------------------------------------------|
| `onInit`  | Executed during initialization, before theme loading               |
| `onStart` | Executed after theme loading, immediately before command execution |
| `onExit`  | Executed after command execution, regardless of its exit status    |

Hooks are optional. The core checks whether a hook is defined before invoking it, so commands do not need to implement every hook.

For example, a command can define hooks to initialize resources, perform setup and clean up after execution:

```bash
function fz::<command>::fz::hook::onInit()
{
	...
}

function fz::<command>::fz::hook::onStart()
{
	...
}

function fz::<command>::fz::hook::onExit()
{
	...
}
```

Hooks receive no arguments. The command name is used internally by the core to locate the corresponding hook.

Keep hooks focused on lifecycle-related tasks and avoid placing command-specific functionality in the core hook dispatcher.

### Code Style

- Use the existing indentation, spacing and formatting conventions.
- Keep generated help output aligned with the existing format.
- Keep Bash compatibility in mind and avoid newer Bash-specific features when a portable alternative is available.

### Internal API

The following functions provide common utilities for internal `fz` functions.

- `fz:api::command [COMMAND ...]`

  Resolves the first available command from the given list and prints its resolved value to standard output. Before resolving each candidate, it removes any alias or shell function with the same name to ensure that `command -v` does not resolve to either of them. Candidates are checked in order, and the search stops at the first successful match. If no command is found, an empty line is printed.

- `fz:api::confirm [MESSAGE]`

  Prompts the user to confirm an action using `fzf`, presenting `Yes` and `No` options. `MESSAGE` is displayed as the prompt header and defaults to `Proceed ?` when omitted. The calling function's name is used as the prompt prefix.

  Returns success if the user selects `Yes`, and failure otherwise.

- `fz:api::fzf [ARG ...]`

  Wraps `fzf`, forwarding all arguments and treating exit status `130` (cancellation) as success. This prevents user cancellation from triggering `pipefail` in calling pipelines.

- `fz:api::fzf::header [KEYBIND ... DESCRIPTION --] ...`

  Generates aligned FZF header lines using the `KEYBIND [KEYBIND...] DESCRIPTION --` syntax. Multiple keybinds can be grouped for the same description. Each group must contain at least one keybind and a description. The trailing `--` is optional for the last group.

  Keybinds are displayed separated by ` / `, and dots are automatically generated to align descriptions.

  Returns the formatted header through standard output.

### Completions

When adding or removing commands, make sure both Bash and Zsh completions continue to work.

The top-level command list is generated automatically from the available `fz::*` functions. Do not duplicate command names manually in completion definitions.

Commands may also provide their own completions for arguments and subcommands by defining a completion function in their private namespace:

```bash
function public:fz::<command>::fz::completion()
{
	...
}
```

The completion function is associated with the corresponding command by its name:

```text
fz::<command>
    |
    +-- public:fz::<command>::fz::completion
```

This allows commands to provide argument or subcommand completions without requiring changes to the global completion implementation. For example, `public:fz::kill::fz::completion` provides completions for `fz::kill`.

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
