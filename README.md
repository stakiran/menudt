# menudt
Customizable formatted datetime string selector based on autohotkey.

![menudt_demo](https://user-images.githubusercontent.com/23325839/71077878-9def3a00-21cb-11ea-83ee-ab39aa9f4d47.gif)

## Requirement
- AutoHotkey Version 1.1.30+

## Install
Get.

```
$ git clone https://github.com/stakiran/menudt
```

Set your config about using text editor.

```
$ cd menudt
$ copy config.ahk.sample config.ahk
$ (Edit the variable TEXT_EDITOR_PATH in config.ahk to your own)
```

If needed, build and generate an exe file.

```
$ copy build.ahk.sample build.ahk
$ (Edit build.ahk to your own)
$ build.ahk
```

Finally, set the menudt path to your daily using .ahk file.

For example:

```ahk
; Use ScrollLock key.
ScrollLock::run, D:\bin\menudt\menudt.exe
```

```ahk
; Use Alt + D key.
!d::run, D:\bin\menudt\menudt.exe
```

## How to use
Press your hotkey, and select.

## FAQ

### Q: How to customize menu items?
Ans: Edit menudt.ahk directly.

- Step1: Create your favorite formatted string with `FormatTime` etc.
- Step2: Set step1's variable to `builder.add()`

### Q: What is menu position detemination algorithm?
Ans: See `determin_showpos()` function.

Basically the current caret pos, but if not working then the current mouse cursor position.

## License
[MIT License](LICENSE)

## Author
[stakiran](https://github.com/stakiran)
