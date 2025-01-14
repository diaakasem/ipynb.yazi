# Yazi ipynb Preview Plugin

A plugin for [Yazi](https://github.com/sxyazi/yazi) file manager that enables preview of Jupyter Notebook (.ipynb) files by converting them to markdown and rendering them in the preview pane.

## Prerequisites

1. Install Rust toolchain:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

2. Install ipynb-to-md converter:
```bash
cargo install ipynb-to-md
```

3. Install mdcat for markdown rendering:
```bash
cargo install mdcat
```

## Installation

1. Ensure you place the plugin in `~/.config/yazi/plugins/` directory

```bash
git clone https://github.com/diaakasem/ipynb.yazi ~/.config/yazi/plugins/ipynb.yazi
```

1. Add the following to your Yazi config file (`~/.config/yazi/yaiz.toml`):

```toml
[plugin]
prepend_previewers = [
	{ name = "*ipynb",                      run = "ipynb" },
]
```


## Usage

Once installed, Yazi will automatically preview .ipynb files using this plugin. Simply navigate to a Jupyter Notebook file and the preview pane will show the rendered notebook content.

## License

MIT
