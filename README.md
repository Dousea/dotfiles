# dotfiles

My shell setup, managed with [chezmoi](https://www.chezmoi.io): zsh, tmux, Neovim
([Dousea/nvim](https://github.com/Dousea/nvim)) and a handful of CLI tools.

Supported: Fedora, Debian/Ubuntu (including WSL and Proxmox), macOS.

## Setup from a fresh shell

### 1. Install `curl` and `git`

```sh
sudo apt-get update && sudo apt-get install -y curl git    # Debian/Ubuntu
sudo dnf install -y curl git                               # Fedora
xcode-select --install                                     # macOS (for git)
```

On a root shell (e.g. Proxmox), drop the `sudo`.

### 2. Install chezmoi and apply the dotfiles

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply Dousea
```

This installs chezmoi to `~/.local/bin`, clones this repo to
`~/.local/share/chezmoi` and applies it. Along the way it:

1. Asks for the machine profile (see [Profiles](#profiles)). Press Enter for `full`.
2. Asks for the passphrase of the age key that decrypts the private files
   (currently `~/.ssh/config`). Without a terminal it skips them; run
   `chezmoi apply` from a terminal later to add them.
3. Installs packages with `dnf`, `apt-get` or Homebrew (asks for your `sudo`
   password): zsh, tmux, git, fzf, ripgrep, fd, bat, btop, ncdu and build tools.
   On macOS it installs Homebrew first if it's missing.
4. Installs [mise](https://mise.jdx.dev) and the tools in
   `~/.config/mise/config.toml`: Neovim, eza, zoxide, oh-my-posh, lazygit,
   lazydocker, uv and Node LTS.
5. Clones the Neovim config, zinit and tpm.

If a step fails, fix the cause and run `~/.local/bin/chezmoi apply` again.

### 3. Make zsh your login shell

```sh
chsh -s "$(command -v zsh)"
```

As root, or for another user: `sudo chsh -s "$(command -v zsh)" <user>`.

If `chsh` says the user doesn't exist in `/etc/passwd` (accounts managed by a
cloud provider, e.g. Google Cloud OS Login), start zsh from bash instead by
adding this to the end of `~/.bashrc`:

```sh
[[ $- == *i* && -x /usr/bin/zsh && -z $ZSH_VERSION ]] && exec /usr/bin/zsh -l
```

### 4. Log out and back in

The first zsh start takes a few seconds while zinit downloads the plugins.
Over SSH, tmux starts automatically in a session called `main`.

### 5. Install the tmux plugins (`full` profile)

Inside tmux, press `C-a` then `I` (capital i).

### 6. Open Neovim once (`full` profile)

Run `nvim` and wait for lazy.nvim to install the plugins, then quit and reopen.
Mason then installs the language servers and formatters in the background.

### 7. Use a Nerd Font in your terminal

The prompt and the tmux status bar use [Nerd Font](https://www.nerdfonts.com)
icons. Set one in the terminal you connect *from*; nothing needs installing on
remote machines.

## Updating a machine

```sh
chezmoi update    # or czu
```

This pulls this repo and applies it. It also pulls the Neovim config (at most
hourly) and zinit and tpm (weekly), and reinstalls the mise tools if their list
changed. Then pick up the changes:

- zsh: `reload` in each open shell, or open a new one.
- tmux: `C-a r` reloads the config.

If `chezmoi update` stops with an error about the config file or encryption,
the config template changed. Run `chezmoi init`, then `chezmoi apply`.

The tools themselves update separately:

| What | How |
| --- | --- |
| mise tools (Neovim, eza, zoxide, …) | `mise upgrade` |
| zsh plugins | `zinit update --all` |
| tmux plugins | `C-a U` inside tmux |
| Neovim plugins | `:Lazy sync` in Neovim |
| system packages | `sudo dnf upgrade`, `sudo apt upgrade` or `brew upgrade` |

## Profiles

| | `full` (default) | `minimal` |
| --- | --- | --- |
| zsh plugins | zinit | the distro's `zsh-autosuggestions` and `zsh-syntax-highlighting` |
| tmux plugins | tpm, with CPU/memory in the status bar | none, hostname in the status bar |
| Neovim config | yes | no |
| C/C++ build tools | yes | no |
| mise tools | yes | yes |

To switch, change `profile` in `~/.config/chezmoi/chezmoi.toml` and run
`chezmoi apply`.

## Day to day

| Command | What it does |
| --- | --- |
| `chezmoi update` (`czu`) | pull this repo and apply it |
| `chezmoi edit <file>` (`cze`) | edit the source of a managed file |
| `chezmoi diff` (`czd`) | show what `apply` would change |
| `chezmoi apply` (`cza`) | apply the source to `$HOME` |
| `chezmoi cd` (`czcd`) | open a shell in the source repo |
| `mise upgrade` | update the mise-managed tools (see [Updating](#updating-a-machine)) |
| `tm` | open or switch to a project's or server's tmux session |

Machine-specific aliases go in `~/.aliasrc`, which isn't managed here.

### Private files

Files with secrets or private details (server addresses, for example) are
stored encrypted with [age](https://age-encryption.org), so they can live in
this public repo. The key itself is in the repo as `key.txt.age`, encrypted
with a passphrase; each machine decrypts it once into
`~/.config/chezmoi/key.txt`.

- Add or update a private file: `chezmoi add --encrypt <file>`
- Edit one in place: `chezmoi edit <file>` (decrypts and re-encrypts for you)

## tmux

- The prefix is `C-a`.
- Use one session per project or server. `tm` (or `C-a f` inside tmux) picks
  one of your sessions, an SSH host (from `~/.ssh/config` and your zsh history)
  or one of zoxide's directories with fzf, and opens a session for it. `tm
  <host>` connects straight to a known SSH host; any other `tm <query>` jumps to
  the best zoxide match. An SSH session closes when the connection ends. Move
  between sessions with `C-a s` (tree), `C-a (` / `C-a )` and `C-a b` (back).
- In an SSH session opened by `tm`, only the server's tmux is visible and `C-a`
  goes to it; the local tmux is `C-b` there (`C-b f`, `C-b b`).
- `C-a ?` shows a cheat sheet. Wide terminals show a dim tip in the status bar;
  `C-a :set @tips off` hides it.
- With the `full` profile, sessions are saved every 15 minutes and restored when
  tmux starts again, e.g. after a reboot.
- `F12` switches the local tmux's keys off, so they reach a tmux running over
  SSH inside it. Press `F12` again to switch them back on.
- Copying in tmux also reaches the local clipboard from a remote machine,
  through OSC 52. That needs a terminal that supports it (e.g. Ghostty, kitty,
  foot, WezTerm). VTE terminals (GNOME Terminal, Ptyxis) don't; hold Shift
  while selecting to use the terminal's own selection.
