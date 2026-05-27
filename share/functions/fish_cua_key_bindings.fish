function fish_cua_key_bindings -d "CUA (Windows-standard) key bindings"
    if contains -- -h $argv
        or contains -- --help $argv
        echo "Sorry but this function doesn't support -h or --help"
        return 1
    end

    if not set -q argv[1]
        bind --erase --all --preset
        if test "$fish_key_bindings" != fish_cua_key_bindings
            __fish_change_key_bindings fish_cua_key_bindings
            set fish_bind_mode default
        end
    end

    if not contains -- -s $argv
        set argv -s $argv
    end

    __fish_shared_key_bindings $argv
    or return

    bind --preset $argv right forward-char
    bind --preset $argv left backward-char

    # Ctrl+Arrow: word (punctuation) boundaries — CUA standard.
    bind --preset $argv ctrl-right forward-word
    bind --preset $argv ctrl-left backward-word

    # TODO: bind alt-right/alt-left to drag-word-right/drag-word-left once those
    # ReadlineCmd variants exist. In CUA mode these slots are free (unlike emacs/macOS modes
    # where alt-arrow does directory navigation). See the "word dragging" tracking issue.

    # Shift+Arrow: extend selection by one character.
    bind --preset $argv shift-right select-forward-char
    bind --preset $argv shift-left select-backward-char

    # Ctrl+Shift+Arrow: extend selection by word (matching Ctrl+Arrow boundaries).
    bind --preset $argv ctrl-shift-right select-forward-word
    bind --preset $argv ctrl-shift-left select-backward-word

    bind --preset $argv shift-home select-beginning-of-line
    bind --preset $argv shift-end select-end-of-line
    bind --preset $argv ctrl-shift-home select-beginning-of-buffer
    bind --preset $argv ctrl-shift-end select-end-of-buffer

    bind --preset $argv delete delete-char
    bind --preset $argv backspace backward-delete-char
    bind --preset $argv shift-backspace backward-delete-char
    bind --preset $argv ctrl-backspace backward-kill-word
    bind --preset $argv ctrl-delete kill-word

    bind --preset $argv home beginning-of-line
    bind --preset $argv end end-of-line

    # Ctrl+A = select all (overrides emacs beginning-of-line; Home already covers that).
    bind --preset $argv ctrl-a select-all

    # Ctrl+C: copy selected text, or cancel the current input if nothing is selected.
    bind --preset $argv ctrl-c __fish_cua_ctrl_c

    # Ctrl+X: cut selected text, or kill to end of line if nothing is selected.
    bind --preset $argv ctrl-x __fish_cua_ctrl_x

    # Ctrl+V = paste (already set by __fish_shared_key_bindings; restated for clarity).
    bind --preset $argv ctrl-v fish_clipboard_paste

    bind --preset $argv ctrl-z undo
    # Ctrl+Y = redo (overrides emacs yank; use ctrl-v for paste in CUA mode).
    bind --preset $argv ctrl-y redo
    bind --preset $argv ctrl-shift-z redo

    bind --preset $argv ctrl-p up-or-search
    bind --preset $argv ctrl-n down-or-search

    bind --preset $argv ctrl-r history-pager
    bind --preset $argv ctrl-f history-pager

    bind --preset $argv ctrl-h backward-delete-char
    bind --preset $argv ctrl-g cancel
    bind --preset $argv ctrl-_ undo
end
