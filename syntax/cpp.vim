" Catch errors {{{1

" Highlight deprecated so I spell it right.
syn match uncppDeprecated "\S\+_\zsDEPRECATED\>" display

hi def link uncppDeprecated Special
