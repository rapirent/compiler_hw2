# compiler HW2

## Summary
- author：Kuo Teng, Ding
- student ID：E94036209
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

4. use gcc(or you can use cc, too)
```
gcc -o output lex.yy.c y.tab.c
```

5. use pipeline to input your input file
```
./output < [your file]
```
