### setting.json

```json
  // ##############################################################
  // vim setup
  "vim.leader": "<Space>",
  "vim.normalModeKeyBindingsNonRecursive": [
    // NAVIGATION
    // switch b/w buffers
    { "before": ["<S-h>"], "commands": [":bprevious"] },
    { "before": ["<S-l>"], "commands": [":bnext"] },
    // splits
    { "before": ["leader", "v"], "commands": [":vsplit"] },
    { "before": ["leader", "s"], "commands": [":split"] },
    // panes
    {
      "before": ["leader", "h"],
      "commands": ["workbench.action.focusLeftGroup"]
    },
    {
      "before": ["leader", "j"],
      "commands": ["workbench.action.focusBelowGroup"]
    },
    {
      "before": ["leader", "k"],
      "commands": ["workbench.action.focusAboveGroup"]
    },
    {
      "before": ["leader", "l"],
      "commands": ["workbench.action.focusRightGroup"]
    },
    {
      "before": ["leader", "d"],
      "commands": [{ "command": "editor.action.showDefinitionPreviewHover" }]
    },
    {
      "before": ["leader", "w"],
      "commands": ["workbench.action.closeActiveEditor"]
    }
  ],
  "vim.visualModeKeyBindings": [
    // Stay in visual mode while indenting
    { "before": ["<"], "commands": ["editor.action.outdentLines"] },
    { "before": [">"], "commands": ["editor.action.indentLines"] },
    // Move selected lines while staying in visual mode
    { "before": ["J"], "commands": ["editor.action.moveLinesDownAction"] },
    { "before": ["K"], "commands": ["editor.action.moveLinesUpAction"] },
    // toggle comment selection
    { "before": ["leader", "c"], "commands": ["editor.action.commentLine"] }
  ],
  "vim.startInInsertMode": false,
  "vim.useCtrlKeys": false,
  "vim.overrideCopy": false,
  // 一部vim無効化
  "vim.handleKeys": {
    "<C-w>": false, // タブの削除はデフォ
    "<C-d>": false // ワード複数選択はvscodeデフォルトで
  }

```

### keybinding
```json

// Place your key bindings in this file to override the defaults
[
  {
    "key": "shift+alt+down",
    "command": "editor.action.copyLinesDownAction",
    "when": "editorTextFocus && !editorReadonly"
  },
  {
    "key": "shift+alt+up",
    "command": "editor.action.copyLinesUpAction",
    "when": "editorTextFocus && !editorReadonly"
  },
  // terminal
  {
    "key": "ctrl+shift+j",
    "command": "workbench.action.togglePanel"
  },
  {
    "key": "ctrl+shift+n",
    "command": "workbench.action.terminal.new",
    "when": "terminalFocus"
  },
  {
    "key": "ctrl+shift+w",
    "command": "workbench.action.terminal.kill",
    "when": "terminalFocus"
  },
  // show definition
  {
    "before": ["<leader>", "d"],
    "commands": ["editor.action.showDefinitionPreviewHover"]
  },
  // file tree
  {
    "command": "workbench.action.toggleSidebarVisibility",
    "key": "ctrl+h"
  }
]
```