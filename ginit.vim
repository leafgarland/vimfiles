GuiFont Source\ Code\ Pro:h12

" Zoom font size {{{
let s:zoom_level=split(split(g:GuiFont, ',')[0], ':')[1][1:]
function! s:ChangeZoom(zoomInc)
  let s:zoom_level = min([max([4, (s:zoom_level + a:zoomInc)]), 28])
  call GuiFont(substitute(g:GuiFont, ':h\d\+', ':h' . s:zoom_level, ''))
endfunction

nnoremap coz :<C-U>call <sid>ChangeZoom(-1 * (v:count == 0 ? 1 : v:count))<CR>
nnoremap coZ :<C-U>call <sid>ChangeZoom(1 * (v:count == 0 ? 1 : v:count))<CR>

nnoremap com :call GuiWindowMaximized(!g:GuiWindowMaximized)<CR>
nnoremap cof :call GuiWindowFullScreen(!g:GuiWindowFullScreen)<CR>
