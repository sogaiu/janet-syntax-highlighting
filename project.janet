(declare-project
  :name "janet-syntax-highlighting"
  :url "https://github.com/sogaiu/janet-syntax-highlighting"
  :repo "git+https://github.com/sogaiu/janet-syntax-highlighting.git")

(declare-source
  :source @["syn-high"])

(declare-binscript
  :main "jshd"
  :is-janet true)

