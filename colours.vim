let s:BuiltinGroups = ["ColorColumn","Conceal","Cursor","CursorColumn","CursorIM","CursorLine","CursorLineNr","DiffAdd","DiffChange","DiffDelete","DiffText","Directory","EndOfBuffer","ErrorMsg","FoldColumn","Folded","IncSearch","LineNr","MatchParen","Menu","ModeMsg","MoreMsg","NonText","Normal","NormalNC","Pmenu","PmenuSbar","PmenuSel","PmenuThumb","Question","QuickFixLine","Scrollbar","Search","SignColumn","SpecialKey","SpellBad","SpellCap","SpellLocal","SpellRare","StatusLine","StatusLineNC","Substitute","TabLine","TabLineFill","TabLineSel","TermCursor","TermCursorNC","Title","Tooltip","VertSplit","Visual","VisualNOS","WarningMsg","Whitespace","WildMenu"]

function! GetAttr(higroup, attr)
    let attr = a:attr
    let id = synIDtrans(hlID(a:higroup))
    if synIDattr(id, 'reverse') == 1
      let attr = attr == 'fg' ? 'bg' :
            \    attr == 'bg' ? 'fg' :
            \    attr
    endif

    if attr !~ '\(fg\|bg\|sp\)'
      return synIDattr(id, attr) ? v:true : v:false
    endif

    let colour = synIDattr(id, attr)

    if colour =~ 'fg\|bg'
      return synIDattr(hlID('Normal'), colour)
    elseif empty(colour) && a:higroup != 'Normal'
      return synIDattr(hlID('Normal'), attr)
    endif

    return colour
endfunction

function! IsLink(higroup)
    return synIDattr(synIDtrans(hlID(a:higroup)), 'name') != a:higroup
endfunction

function! IsCleared(higroup)
    return empty(filter(['fg','bg','italic','bold','underline','undercurl'], {i,v -> synIDattr(hlID(a:higroup), v) != ''}))
endfunction

function! GetStyle(higroup)
  let style = {
        \ 'bg':GetAttr(a:higroup, 'bg'),
        \ 'fg':GetAttr(a:higroup, 'fg'),
        \ 'sp':GetAttr(a:higroup, 'sp'),
        \ 'bold':GetAttr(a:higroup, 'bold'),
        \ 'italic':GetAttr(a:higroup, 'italic'),
        \ 'underline':GetAttr(a:higroup, 'underline'),
        \ 'undercurl':GetAttr(a:higroup, 'undercurl')}
  for [k,v] in items(style)
    if empty(v)
      unlet style[k]
    endif
  endfor
  return style
endfunction

function! GetStyles(groups)
  let groups = filter(a:groups, {idx, val -> !IsLink(val) && !IsCleared(val)})
  let styles = map(groups, {idx, val -> {'group':val, 'style':GetStyle(val)}})
  let result = {}
  for d in styles
    let key = string(d.style)
    if has_key(result, key)
      call add(result[key].groups, d.group)
    else
      let result[key] = {'groups':[d.group], 'style':d.style}
    endif
  endfor
  return values(result)
endfunction

function! GetColours(styles)
  let colours = []
  for group in a:styles
    for a in ['fg', 'bg', 'sp']
      if !has_key(group.style, a)
        continue
      endif
      let colour = group.style[a]
      let i = index(colours, colour)
      if i == -1
        let i = len(add(colours, colour)) - 1
      endif
      let group.style[a] = i
    endfor
  endfor
  return {'colours':colours, 'styles':a:styles}
endfunction

function! GetStuff()
  let groups = getcompletion('', 'highlight')
  let styles = GetColours(GetStyles(copy(groups)))
  let linklist = map(filter(groups, {i,v -> IsLink(v)}), {i,v -> [synIDattr(synIDtrans(hlID(v)), 'name'), v]})
  let links = {}
  for [k,v] in linklist
    if has_key(links, k)
      call add(links[k], v)
    else
      let links[k] = [v]
    endif
  endfor
  let styles.links = links

  return json_encode(styles)
endfunction

function! RunStuff()
  Verbose echo GetStuff()
  normal dd
  setf json
  normal ==
endfunction






