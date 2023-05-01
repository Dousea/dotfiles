EDITOR=vim

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# This option both imports new commands from the history file, and also causes
# your typed commands to be appended to the history file (the latter is like
# specifying INC_APPEND_HISTORY, which should be turned off if this option is
# in effect). The history lines are also output with timestamps ala
# EXTENDED_HISTORY (which makes it easier to find the spot where we left off
# reading the file after it gets re-written).
setopt SHARE_HISTORY

# Remove superfluous blanks from each command line being added to the history
# list.
setopt HIST_REDUCE_BLANKS

# By default, shell history that is read in from files is split into words on
# all white space. This means that arguments with quoted whitespace are not
# correctly handled, with the consequence that references to words in history
# lines that have been read from a file may be inaccurate. When this option is
# set, words read in from a history file are divided up in a similar fashion to
# normal shell command line handling. Although this produces more accurately
# delimited words, if the size of the history file is large this can be slow.
# Trial and error is necessary to decide.
setopt HIST_LEX_WORDS

# Do not enter command lines into the history list if they are duplicates of
# the previous event.
setopt HIST_IGNORE_DUPS

# Allow comments even in interactive shells.
setopt INTERACTIVE_COMMENTS

# No beep on error in ZLE.
setopt NO_BEEP

# Try to correct the spelling of commands.
setopt CORRECT NO_CORRECT_ALL
