"======================================================================
"
" floater_reuse.vim - 
"
" Created by skywind on 2021/12/15
" Last Modified: 2021/12/15 06:48:57
"
"======================================================================

" vim: set ts=4 sw=4 tw=78 noet :
function! asyncrun#runner#floaterm_reuse#run(opts)
	" 获取当前的 Floaterm buffer 编号
	let curr_bufnr = floaterm#buflist#curr()
	" 如果 Floaterm 不存在，则创建一个新的 Floaterm 终端
	if curr_bufnr <= 0
		let cmd = 'FloatermNew '
		if has_key(a:opts, 'position')
			let cmd .= ' --position=' . fnameescape(a:opts.position)
		endif
		if has_key(a:opts, 'width')
			let cmd .= ' --width=' . fnameescape(a:opts.width)
		endif
		if has_key(a:opts, 'height')
			let cmd .= ' --height=' . fnameescape(a:opts.height)
		endif
		if has_key(a:opts, 'title')
			let cmd .= ' --title=' . fnameescape(a:opts.title)
		endif
		exec cmd
		" 使用 FloatermNew 创建终端，并指定位置和大小
		" execute 'FloatermNew --position=bottom --width=0.8 --height=0.4'
		let curr_bufnr = floaterm#curr()
	endif
    
	call floaterm#terminal#open_existing(curr_bufnr)
	" 检查是否处于 silent 模式，决定是否隐藏 Floaterm
	if has_key(a:opts, 'silent') && a:opts.silent == 1
			FloatermHide!
	endif

	" 发送当前目录的切换命令
	" let cmd = 'cd ' . shellescape(getcwd())
	" call floaterm#terminal#send(curr_bufnr, [cmd])

	" 发送需要执行的命令
	call floaterm#terminal#send(curr_bufnr, [a:opts.cmd])

	" 停止插入模式
	stopinsert

	" 如果当前文件类型是 floaterm 且自动进入插入模式的配置开启，则进入插入模式
	if &filetype == 'floaterm' && g:floaterm_autoinsert
			call floaterm#util#startinsert()
	endif

	return 0
endfunction



