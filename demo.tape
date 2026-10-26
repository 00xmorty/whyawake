Output "demo.gif"
Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1180
Set Height 640
Set Padding 24
Set TypingSpeed 15ms
Hide
Type "export PS1='demo $ '; clear"
Enter
Sleep 500ms
Show
Type "./whyawake --assertions-file tests/fixtures/assertions.txt --log-file tests/fixtures/log.txt"
Enter
Sleep 7s
