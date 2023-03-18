# LuaPlatformBitOperationLib
一言以蔽之：试探平台整数上限，并以此动态实现位运算中如bnot反转定长的问题，不用依赖定长bit了（负数补码）

# 支持的位运算
### BAND
### BOR
### BXOR
### BNOT
### SHL
### SHR
剩下未提供，自行解决，本库目的是解决Lua53之后定义了上述6个位运算指令在低版本Lua上等效依附平台实现位运算。
