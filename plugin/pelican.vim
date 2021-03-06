" pelican.vim
" Author:  mt3, edthedev
" URL:     https://github.com/edthedev/pelican.vim
" Version: 0.1.1
" License: Same as Vim itself (see :help license)

" ==============
" Configuration
" ==============

" if !exists('g:pelican_git_master')
"     help('*pelican.vim*')
" endif

" ============
" Setup Tasks
" ============

" 1. Install pelican
function! pelican#install()
    echom 'Installing Pelican...'
    execute '!pip install --upgrade pelican'
endfunction

" 1. Install pelican
function! pelican#sudo_install()
    echom 'Installing Pelican with superuser permissions...'
    execute '!sudo pip install --upgrade pelican'
endfunction

" 2. Init a new blog 
function! pelican#initblog()
    echom 'Created new blog source files at '.g:pelican_blog_source
    execute '!mkdir -p '.g_pelican_blog_source
    execute '!cd '.g:pelican_blog_source
    execute '!setvirtualenvproject'
    execute '!pelican-quickstart'
    echom 'Attempting to push all content from '.g:pelican_blog_source.' to remote Git repository at '.g:pelican_git_master
    execute '!cd '.g:pelican_blog_source.';git remote add origin '.g:pelican_git_master
    execute '!cd '.g:pelican_blog_source.';git push -u origin --all'
endfunction

" 3. Configure Pelcian
function! pelican#config()
    execute ':e '.g:pelican_blog_source.'/pelicanconf.py'
endfunction

" 5. Or Clone your existing blog from Git 
function! pelican#clone()
    echom 'Cloned blog source into '.g:pelican_blog_source
    execute '!git clone '.g:pelican_git_master.' '.g:pelican_blog_source
    execute '!ls '.g:pelican_blog_source
endfunction


" ==============
" Compose Tasks
" ==============
" I am leaving this somewhat feature incomplete, for now, since alternate plugins are available.
"  For example, http://github.com/edthedev/minion

" Open your Pelican content directory.
function! pelican#open()
    execute ':e '.g:pelican_blog_source.'/content'
endfunction

" Open all of your blog post drafts
function! pelican#drafts()
    echom 'Opening all files in '.g:pelican_blog_source.'/drafts'
    execute ':argadd '.g:pelican_blog_source.'/drafts/*'
    execute ':buffers'
endfunction

" ==============
" Publish Tasks
" ==============

" Convert Rst posts to HTML output
function! pelican#rst2html()
    " Assumes pelican.conf.py and content folder exist in pelican_blog_source
    " folder.
    execute '!pelican -s '.g:pelican_blog_source.'/pelicanconf.py '.g:pelican_blog_source.'/content -o '.g:pelican_blog_html
    echom 'Generated HTML output at '.g:pelican_blog_html
    " execute '!make html'
    " TODO if auto-regenerate flag is set
    " execute '!make regenerate'
endfunction

" Publish HTML content to remote server.
"   with Rsync
function! pelican#publish()
    execute '!rsync --verbose --recursive '.g:pelican_blog_html.'/* '.g:pelican_publish_server
    echom 'Published HTML to '.g:pelican_publish_server
endfunction

" ===========
" Sync Tasks
" ===========

" update your blog from Git
function! pelican#pull()
    execute '!cd '.g:pelican_blog_source.';git pull '.g:pelican_git_master
endfunction

" Commit all the things!
function! pelican#commit()
    execute '!cd '.g:pelican_blog_source.'; git commit -a -m "Checking in latest blog updates."'
    execute '!cd '.g:pelican_blog_source.'; git push origin master'
endfunction

" ==================
" Keyboard Mappings
" ==================

" Map keyboard shortcuts by default.
if !exists('g:pelican_map_keys')
	let g:pelican_map_keys = 1
endif

if g:pelican_map_keys
    " Install 

    " ":nnoremap <leader>pi :call pelican#install()<Cr>
    " ":nnoremap <leader>px :call pelican#sudo_install()<Cr>
    " ":nnoremap <leader>px :call pelican#initblog()<Cr>
    " ":nnoremap <leader>px :call pelican#config()<Cr>
    " ":nnoremap <leader>pc :call pelican#clone()<Cr>

    " Edit
    :nnoremap <leader>pu :call pelican#pull()<Cr>
    :nnoremap <leader>po :call pelican#open()<Cr>
    :nnoremap <leader>pd :call pelican#drafts()<Cr>
    :nnoremap <leader>pc :call pelican#commit()<Cr>

    " Publish
    :nnoremap <leader>ph :call pelican#rst2html()<Cr>
    :nnoremap <leader>pp :call pelican#publish()<Cr>
endif


" ===========
" Older Code
" ===========
"
"


"
"    " start server on http://localhost:8000
"    function! pelican#startserver()
"        execute '!make serve'
"        " TODO or run webserver with python
"        " execute '!cd output && python -m SimpleHTTPServer'
"    endfunction
"
"    " stop server
"    function! pelican#stopserver()
"        execute '!./develop_server.sh stop'
"    endfunction
"
"    " publish site
"    function! pelican#publish()
"        execute '!make rsync_upload'
"    endfunction

"" Config {{{
"
"    if exists('g:loaded_pelican') || &cp || v:version < 700
"      finish
"    endif
"    let g:loaded_pelican = 1
"
"    " Directories to search for posts
"    if ! exists('g:pelican_post_dirs')
"      let g:pelican_post_dirs = ['pages']
"    endif
"
"    " Extension used when creating new posts
"    " default = rst
"    if ! exists('g:pelican_post_extension')
"      let g:pelican_post_extension = '.rst'
"    endif
"
"    " Github username for publishing to github
"    if ! exists('g:pelican_github_username')
"      let g:pelican_github_username = 'username.github.com'
"    endif
"
"    " Filetype applied to new posts
"    if ! exists('g:pelican_post_filetype')
"      let g:pelican_post_filetype = 'liquid'
"    endif
"
"    " Template for new posts
"    if ! exists('g:pelican_post_template')
"      let g:pelican_post_template = [
"        \ ' ',
"        \ ':category: "CATEGORY"',
"        \ ':title: "PELICAN_TITLE"',
"        \ ':status: draft',
"        \ ':date: "PELICAN_DATE"',
"        \ ':author: "AUTHOR"',
"        \ '']
"    endif
"
"    " Directory to place generated files in, relative to b:pelican_root_dir.
"    if ! exists('g:pelican_site_dir')
"      let g:pelican_site_dir = 'output'
"    endif
"
"    " Path for projects. Begins from this root and navigates into dir for all 'someapp.settings' files
"    if !exists('g:pelican_project')
"        " cribbed this from django.vim
"        let g:pelican_project = expand('~/pelicanproj')
"    else
"        let g:pelican_project = expand(g:pelican_projects)
"    endif
"
"    if !isdirectory(g:pelican_project)
"        echoerr "Could not access ".g:pelican_project.". Not a directory."
"    endif
"" }}}
"
"" Pelican functions {{{
"    function! s:createApp(foldername)
"        let current_directory = fnamemodify(expand('%:p'), ':h')
"        exec 'chdir '.g:project_directory
"        silent exec '! pelican '.foldername
"        echo "Created new Pelican project at ".join(foldername, '.')
"        if !isdirectory(foldername)
"            call mkdir(foldername)
"            silent exec '!touch '.foldername.'/__init__.py'
"        endif
"        exec 'chdir '.foldername
"    endfunction
"
"    """""""""""""""""""""""""""""""""""
"    " setup pelican
"    "     pip install pelican
"    "     git clone git://github.com/mt3/mt3.github.com.git
"    " settings.py
"    "     AUTHOR = 'mt3'
"    "     DISQUS_SITENAME = 'mt3_disqus'
"    "     GITHUB_URL = 'https://github.com/mt3'
"    "     GOOGLE_ANALYTICS='UA-18066389-2'
"    "     SITEURL = 'http://mt3.github.com'
"    "     SITENAME = 'mt3_site'
"    "     SOCIAL = (('twitter', 'http://twitter.com/mt3'),
"    "               ('github', 'https://github.com/mt3'),
"    "               ('facebook', 'http://www.facebook.com/x.mt3'),)
"    "     TAG_FEED = 'feeds/%s.atom.xml'
"    "     THEME='notmyidea'
"    "     TWITTER_USERNAME = 'mt3'
"    " Push posts, pages, and themes:
"    "     pelican . -o . -s settings.py
"    "     git commit -am "blogging here"
"    "     git push
"    """""""""""""""""""""""""""""""""""
"
"
"
"    " below are cribbed from django.vim
"    """""""""""""""""""""""""""""""""""
"    command! -nargs=? -complete=customlist,django#completions#managmentcommands DjangoManage call django#commands#manage(<q-args>)
"    command! -nargs=1 -complete=customlist,django#completions#projectscomplete DjangoProjectActivate call django#project#activate(<q-args>)
"    command! -nargs=? -complete=customlist,django#completions#managmentcommands DjangoAdmin call django#commands#admin(<q-args>)
"    command! -nargs=? -complete=customlist,django#completions#pypath DjangoCreateApp call django#apps#create_app(<q-args>)
"    command! DjangoCollectStaticLink call django#commands#manage('collectstatic --noinput --link')
"    command! DjangoSyncDb call django#commands#manage('syncdb')
"
"    function! django#utils#vim_open(file, open_as)
"        if a:open_as is 'tab'
"            exec 'tabnew '.a:file
"        elseif a:open_as is 'vsplit'
"            exec 'vsplit '.a:file
"        elseif a:open_as is 'split'
"            exec 'split'.a:file
"        endif
"    endfunction
"
"    function! django#templates#find(name)
"        let file_regex = '**/templates/'.a:name
"        let possible_paths = split(globpath(g:project_directory, file_regex))
"        return possible_paths
"    endfunction
"
"    function! django#commands#manage(command, ...)
"        let file_regex = '**/manage.py'
"        let manage = split(globpath(g:project_directory, file_regex))[0]
"        execute '!python '.manage.' '.a:command
"    endfunction
"
"    function! django#commands#admin(comamnd, ...)
"        execute '!django-admin.py '.a:command
"    endfunction
"
"    function! django#project#activate(project)
"        let file_regex = a:project.'/settings.py'
"        let file = findfile(file_regex, g:django_projects.'**')
"        let g:project_directory = fnamemodify(file, ':p:h:h')
"        let g:project_name = a:project
"        if exists('g:django_activate_virtualenv')
"            if exists('g:virtualenv_loaded') && g:django_activate_virtualenv == 1
"                for env in virtualenv#names(a:project)
"                    call virtualenv#activate(env)
"                    break
"                endfor
"            else
"                echoerr 'VirtualEnv not installed. Not activating.'
"            endif
"        endif
"        if exists('g:django_activate_nerdtree')
"            if exists('g:loaded_nerd_tree') && g:django_activate_nerdtree == 1
"                exec ':NERDTree '.g:project_directory
"            else
"                echoerr "NERDTree not installed. Can not open."
"            endif
"        endif
"        exec 'set path+='.expand(g:project_directory)
"        call ActivateProject(a:project)
"    endfunction
"" }}}
"
"" Utility functions {{{
"    " Print an error message
"    function! s:error(string)
"        echohl ErrorMsg
"        echomsg "Error: ".a:string
"        echohl None
"        let v:errmsg = a:string
"    endfunction
"
"    " Substitute first occurrences of pattern in string with replacement
"    function! s:sub(string, pattern, replacement)
"        return substitute(a:string, '\v\C'.a:pattern, a:replacement, '')
"    endfunction
"
"    " Substitute all occurrences of pattern in string with replacement
"    function! s:gsub(string, pattern, replacement)
"        return substitute(a:string, '\v\C'.a:pattern, a:replacement, 'g')
"    endfunction
"
"    " Returns true if string stars with prefix
"    function! s:startswith(string, prefix)
"        return strpart(a:string, 0, strlen(a:prefix)) ==# a:prefix
"    endfunction
"
"    " Format a file path
"    function! s:escape_path(path)
"        let path = a:path
"        let path = s:gsub(path, '/+', '/')
"        let path = s:gsub(path, '[\\/]$', '')
"        return path
"    endfunction
"
"    " Returns a lowercase string, all non-alphanumeric characters are replaced with dashes
"    function! s:dasherize(string)
"        let string = tolower(a:string)
"        let string = s:gsub(string, '([^a-z0-9])+', '-')
"        let string = s:gsub(string, '(^-*|-*$)', '')
"        return string
"    endfunction
"" }}}
"
"" Post functions {{{
"
"    " returns filename for a new post based on it's title
"    function! s:post_filename(title)
"        return b:pelican_post_dir.'/'.strftime('%Y-%m-%d-').s:dasherize(a:title).g:pelican_post_extension
"    endfunction
"
"    " strip whitespace and escape double quotes
"    function! s:post_title(title)
"        let title = s:gsub(a:title, '(^[ ]*|[ ]*$)', '')
"        let title = s:gsub(title, '[ ]{2,}', ' ')
"        let title = s:gsub(title, '"', '\\&')
"        return title
"    endfunction
"
"    " autocomplete posts
"    function! s:post_list(A, L, P)
"        let prefix   = b:pelican_post_dir.'/'
"        let data     = s:gsub(glob(prefix.'*.*')."\n", prefix, '')
"        let data     = s:gsub(data, '\'.g:pelican_post_extension."\n", "\n")
"        let files    = reverse(split(data, "\n"))
"        let filtered = filter(copy(files), 's:startswith(v:val, a:A)')
"        if ! empty(filtered)
"            return filtered
"        endif
"    endfunction
"
"    " send given filename to the editor using cmd
"    function! s:load_post(cmd, filename)
"        let cmd  = empty(a:cmd) ? 'E' : a:cmd
"        let cmds = {'E': 'edit', 'S': 'split', 'V': 'vsplit', 'T': 'tabnew'}
"        if ! has_key(cmds, cmd)
"            return s:error('Invalid command: '. cmd)
"        else
"            execute cmds[cmd]." ".a:filename
"        endif
"    endfunction
"
"    " create a new blog post
"    function! s:create_post(cmd, ...)
"        let title = a:0 && ! empty(a:1) ? a:1 : input('Post title: ')
"        if empty(title)
"            return s:error('You must specify a title')
"        elseif filereadable(b:pelican_post_dir.'/'.title.g:pelican_post_extension)
"            return s:error(title.' already exists!')
"        endif
"
"        call s:load_post(a:cmd, s:post_filename(title))
"        let error = append(0, g:pelican_post_template)
"        if error > 0
"            return s:error("Couldn't create post.")
"        else
"            let &ft = g:pelican_post_filetype
"            let date = strftime('%a %b %d %T %z %Y')
"            silent! %s/PELICAN_TITLE/\=s:post_title(title)/g
"            silent! %s/PELICAN_DATE/\=date/g
"        endif
"    endfunction
"
"    " edit a post
"    function! s:edit_post(cmd, post)
"        let file = b:pelican_post_dir.'/'.a:post.g:pelican_post_extension
"        if filereadable(file)
"            return s:load_post(a:cmd, file)
"        else
"            return s:error('File '.file.' does not exist! Try :J'.a:cmd.'post! to create a new post.')
"        endif
"    endfunction
"
"    " create/edit a post. used by :Ppost to determine if either editing or creating a post
"    function! s:open_post(create, cmd, ...)
"        if a:create
"            return s:create_post(a:cmd, a:1)
"        else
"            return s:edit_post(a:cmd, a:1)
"        endif
"    endfunction
"
"    " return command used to build blog
"    function! s:pelican_bin()
"      let bin = 'pelican --autoreload '
"      " if filereadable(b:pelican_root_dir.'/Gemfile')
"      "   let bin = 'bundle exec '.bin
"      " endif
"      let bin .= b:pelican_root_dir.' '.b:pelican_root_dir.'/'.g:pelican_site_dir
"      return bin
"    endfunction
"
"    " return 'pelican' or 'bundle exec pelican'
"    function! s:pelican_build(cmd)
"        if exists('g:pelican_build_command') && ! empty(g:pelican_build_command)
"            let bin = g:pelican_build_command
"        else
"            let bin = s:pelican_bin()
"        endif
"        echo 'Building, this may take a moment'
"        let lines = system(bin.' '.a:cmd)
"        if v:shell_error != 0
"            return s:error('Build failed')
"        else
"            echo 'Site built!'
"        endif
"    endfunction
"
"    " register new user command
"    function! s:define_command(cmd)
"        exe 'command! -buffer '.a:cmd
"    endfunction
"" }}}
"
"" Initialization {{{
"
"    " register plugin commands
"    "   :Ppost[!]  - edit in current buffer
"    "   :PSpost[!] - edit in a split
"    "   :PVpost[!] - edit in a vertical split
"    "   :PTpost[!] - edit in a new tab
"    function! s:register_commands()
"        for cmd in ['', 'S', 'V', 'T']
"            call s:define_command('-bang -nargs=? -complete=customlist,s:post_list P'.cmd.'post :call s:open_post(<bang>0, "'.cmd.'", <q-args>)')
"        endfor
"        call s:define_command('-nargs=* Pbuild call s:pelican_build("<args>")')
"    endfunction
"
"    " try to locate _posts directory
"    function! s:find_pelican(path) abort
"        let cur_path = a:path
"        let old_path = ""
"        while old_path != cur_path
"            for dir in g:pelican_post_dirs
"                let dir      = s:escape_path(dir)
"                if isdirectory(cur_path.'/'.dir)
"                    return [cur_path, cur_path.'/'.dir]
"                endif
"            endfor
"            let old_path = cur_path
"            let cur_path = fnamemodify(old_path, ':h')
"        endwhile
"        return ['', '']
"    endfunction
"
"    " initialize plugin if Pelican blog detected
"    function! s:init(path)
"        let [root_dir, post_dir] = s:find_pelican(a:path)
"        if empty(post_dir) || empty(root_dir)
"            return
"        endif
"        let b:pelican_root_dir = root_dir
"        let b:pelican_post_dir = post_dir
"        silent doautocmd User Pelican
"    endfunction
"
"    augroup pelican_commands
"        autocmd!
"        autocmd User Pelican call s:register_commands()
"    augroup END
"
"    augroup pelican_init
"        autocmd!
"        autocmd BufNewFile,BufReadPost * call s:init(expand('<amatch>:p'))
"        autocmd FileType           netrw call s:init(expand('<afile>:p'))
"        autocmd VimEnter *
"                            \ if expand('<amatch>') == '' |
"                            \   call s:init(getcwd()) |
"                            \ endif
"    augroup END
"" }}}
"
"" TODO to do {{{
"    " write test cases for all methods
"    " finish documenting
"    " comment what functions are working and what have yet to be implemented
"" }}}
"
"" vim:ft=vim:fdm=marker:ts=4:sw=4:sts=4:et
