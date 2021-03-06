" This file is part of vim-force.com plugin
"   https://github.com/neowit/vim-force.com
" File:  vim-force.com.vim
" Author: Andrey Gavrikov 
" Last Modified: 2014-03-10
"
" filetype.vim - detect SFDC Filetypes
"

"force.com related file types
au! BufRead,BufNewFile *.cls,*.trigger,*.resource set filetype=apexcode
" set two file types for apex page: html (for syntax) and apexcode (for compilation and tags)
" use <C-0> for Javascript and <C-U> for html complete
au! BufRead,BufNewFile *.page,*.component,*.scf	set filetype=visualforce | setlocal omnifunc=htmlcomplete#CompleteTags | setlocal completefunc=visualforcecomplete#Complete
" scratch buffer needs 'apexcode' highlighting
au! BufRead,BufNewFile vim-force.com-scratch.txt set filetype=apexcode

" resources with name like *JS.resource are treated as plain javascript files, (i.e. non zip files)
au! BufRead,BufNewFile *JS.resource set filetype=apexcode.javascript | set syntax=javascript

" unpacked resources are stored in projet_root/resources_unpacked/... folder
" see also end of apexResource.vim, where handling of .resource and its unpacked content is defined
au! BufRead,BufNewFile */resources_unpacked/*.js set filetype=apexcode.javascript | set syntax=javascript
au! BufRead,BufNewFile */resources_unpacked/*.html set filetype=apexcode.html | set syntax=html | setlocal omnifunc=htmlcomplete#CompleteTags

" check if we shall let tern_for_vim to become javascript 'omnifunc'
if &runtimepath !~ 'tern_for_vim'
	au! BufRead,BufNewFile *JS.resource setlocal omnifunc=javascriptcomplete#CompleteJS
	au! BufRead,BufNewFile */resources_unpacked/*.js setlocal omnifunc=javascriptcomplete#CompleteJS
endif


