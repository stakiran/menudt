; menudt - version 0.0.1

____preparation____:

SetWorkingDir %A_ScriptDir%
CoordMode Menu, Screen
CoordMode Mouse, Screen
CoordMode Caret, Screen
FileEncoding, CP65001

; config
#Include %A_ScriptDir%\config.ahk

; consts
BASEDIR = %A_ScriptDir%
FULLPATH_SCRIPT = %A_ScriptFullPath%

____main____:

____main_datetime_selections:

FormatTime, d_yyyymmdd,, yyyy/MM/dd
FormatTime, d_hhmmss,, HH:mm:ss
d_dow := get_dowstr()
d_yyyymmdd_hhmmss := d_yyyymmdd " " d_hhmmss
d_yyyymmdd_dow_hhmmss := d_yyyymmdd " (" d_dow ") " d_hhmmss

FormatTime, d_yymmdd_short,, yyMMdd
FormatTime, d_hhmmss_short,, HHmmss
FormatTime, d_hhmm_short,, HHmm
d_yymmdd_hhmmss_short := d_yymmdd_short "_" d_hhmmss_short

____main_menu_construction:

labelname_after_select_menu := "label_do_after_select"
builder := new MenuItemBuilder(labelname_after_select_menu)

builder.add(d_yyyymmdd_dow_hhmmss)
builder.add(d_yyyymmdd_hhmmss)
builder.add(d_hhmmss)
builder.add(d_yymmdd_hhmmss_short)
count_syscmd_edit := builder.add_edit()

builder.show()
Return

____labels____:

label_do_after_select:
selected_idx := builder.get_selected_index()
if(selected_idx==count_syscmd_edit){
  open_with_your_editor(FULLPATH_SCRIPT)
  Return
}
selected_datetimestr := builder.get_selected_content(selected_idx)
copy_method(selected_datetimestr)
paste_method()
; enter_method()
Return

____funcs____:
Return

enter_method(){
  Send,{Enter}
}

paste_method(){
  Send,^v
}

copy_method(s){
  clipboard = %s%
}

open_with_association(fullpath){
  Run, %fullpath%
}

open_with_your_editor(fullpath){
  editor_path := CONFIG.TEXT_EDITOR_PATH
  Run, "%editor_path%" "%fullpath%"
}

determin_showpos(){
  ; Use the caret pos.
  ; But if cannot get, use mouse cursor pos.
  pos := get_mouse_pos()
  pos.x := A_CaretX
  pos.y := A_CaretY
  Return pos
}

get_mouse_pos(){
  MouseGetPos, mousex, mousey

  mousepos := {}
  mousepos.x := mousex
  mousepos.y := mousey
  Return mousepos
}

get_menuitem_index_from_menuname(menuname, delim){
  ls := StrSplit(menuname, delim)
  Return ls[2]
}

is_empty_argument(arg){
  Return arg==""
}

is_not_empty_argument(arg){
  Return arg!=""
}

get_dowstr(){
  FormatTime, downum,, WDay
  dowtable := "SunMonTueWedThuFriSat"
  startpos := ((downum-1)*3)+1
  dowstr := ""
  StringMid, dowstr, dowtable, %startpos%, 3
  return dowstr
}

____classes____:
Return

class Counter {
  __New(){
    this._v := 0
  }

  plus(){
    curv := this._v
    newv := curv + 1
    this._v := newv
  }

  get(){
    Return this._v
  }
}

/*
  About detection of selected menu item

  - 'itemname' format is <ItemName> | <Count>
                                      ^^^^^^^
                           This is important, and means an id
  - 'valuelist' is a list to store each data based on counts
*/
class MenuItemBuilder {
  __New(labelname){
    MENUNAME_ROOT  := "menuname_root"
    MENU_DELIMITOR := " | "
    this._labelname := labelname

    this._rootname := MENUNAME_ROOT
    this._count_delimitor := MENU_DELIMITOR

    this._init()
  }

  _init(){
    rootname := this._rootname

    this._valuelist := Object()

    this._counter := new Counter()
    ; Because ahk is 1-origin.
    this._counter.plus() 

    try {
      Menu, %MENUNAME_ROOT%, DeleteAll
    } catch e {
      ; absorb unavoidable failure because no menu at first time.
    }
  }

  add(text){
    curcount := this._counter.get()
    labelname := this._labelname
    rootname := this._rootname
    delimitor := this._count_delimitor

    Menu, %rootname%, Add, %text% %delimitor% %curcount%, %labelname%

    this._valuelist.Push(text)
    this._counter.plus()
  }

  add_edit(){
    labelname := this._labelname
    rootname := this._rootname
    delimitor := this._count_delimitor

    count_to_detect_on_caller := this._counter.get()
    itemname := "<<Edit file list(&\)>>"

    Menu, %rootname%, Add, %itemname% %delimitor% %count_to_detect_on_caller%, %labelname%
    this._valuelist.Push("__dummy__")
    this._counter.plus()

    Return count_to_detect_on_caller
  }

  show(){
    rootname := this._rootname
    posobj := determin_showpos()
    showx := posobj.x
    showy := posobj.y

    Menu, %rootname%, Show, %showx%, %showy%
  }

  get_selected_index(){
    itemname := A_ThisMenuItem
    ls := StrSplit(itemname, this._count_delimitor)
    selected_idx := ls[2]
    Return selected_idx
  }

  get_selected_content(idx){
    Return this._valuelist[idx]
  }

}
