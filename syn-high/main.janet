# XXX: would be nicer to do dynamically so this doesn't have to be
#      hard-wired?

(import ./names/helix)
(import ./names/nvim-treesitter)
(import ./names/rouge)
(import ./names/janet-ts-mode)
(import ./names/pygments)

(def names
  ["helix"
   "nvim-treesitter"
   "rouge"
   "janet-ts-mode"
   "pygments"])

########################################################################

(def usage
  ``
  Usage: jshd [option] | jshd [name]

  Dump Janet syntax highlighting info for various tools.

    -h, --help                   show this output

    -l, --list                   show supported names

    --bash-completion            output bash-completion bits
    --fish-completion            output fish-completion bits
    --zsh-completion             output zsh-completion bits
    --raw-all                    show all names for completion

  With a name, but no options, output Janet syntax highlighting
  bits for the version of `janet` in use.

  ``)

########################################################################

(def bash-completion
  ``
  _jshd_bindings() {
      COMPREPLY=( $(compgen -W "$(jshd --raw-all)" -- ${COMP_WORDS[COMP_CWORD]}) );
  }
  complete -F _jshd_bindings jshd
  ``)

(def fish-completion
  ``
  function __jshd_complete_specials
    if not test "$__jshd_specials"
      set -g __jshd_specials (jshd --raw-all)
    end

    printf "%s\n" $__jshd_specials
  end

  complete -c jshd -a "(__jshd_complete_specials)" -d 'specials'
  ``)

(def zsh-completion
  ``
  _jshd_specials() {
      local matches=(`jshd --raw-all`)
      compadd -a matches
  }
  compdef _jshd_specials jshd
  ``)

########################################################################

# XXX: work-around for redundancy...
(defn main
  [& argv]
  (def arg (get argv 1))

  (if arg
    (cond
      (or (= "--help" arg) (= "-h" arg))
      (do (print usage) (os/exit 0))
      #
      (or (= "--list" arg) (= "-l" arg))
      (do (each name names (print name)) (os/exit 0))
      #
      (= "--raw-all" arg)
      (do (each name names (print name)) (os/exit 0))
      #
      (= "--bash-completion" arg)
      (do (print bash-completion) (os/exit 0))
      #
      (= "--fish-completion" arg)
      (do (print fish-completion) (os/exit 0))
      #
      (= "--zsh-completion" arg)
      (do (print zsh-completion) (os/exit 0)))
    (do
      (print usage)
      (os/exit 0)))

  (when (not (has-value? names arg))
    (eprintf "unrecognized name: %s" arg)
    (eprin "should be one of: ")
    (each name names
      (eprinf "%s " name))
    (eprint)
    (os/exit 1))

  (def the-name arg)

  (case the-name
    "helix" (helix/main)
    "nvim-treesitter" (nvim-treesitter/main)
    "rouge" (rouge/main)
    "janet-ts-mode" (janet-ts-mode/main)
    "pygments" (pygments/main)
    (eprintf "Should not get here...name was: %s" the-name)))

