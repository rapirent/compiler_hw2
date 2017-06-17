# compiler HW2

## Summary

- author：Kuo Teng, Ding
- student ID：E94036209
- title:Compiler HW2

## Usage


1. extract the zip file

2. change to this dict && use flex

```
cd Compiler_e94036209_hw2
flex Compiler_E94036209_HW2.l
```

3. use yacc(bison)

```
yacc Compiler_E94036209_HW2.y --defines
```

4. use gcc(you can also use cc)

```
gcc lex.yy.c y.tab.c -lfl -o output
```

(you can also use "gcc -o output lex.yy.c y.tab.c")
5. use pipeline to input your input file
```
./output < [your file]
```

## contents

Compiler_E94036209_HW2.l :flex

Compiler_E94036209_HW2.y :yacc

input :個人設定的輸入

## 完成的bonus

- double
- 一般的負數
- 強制轉型

