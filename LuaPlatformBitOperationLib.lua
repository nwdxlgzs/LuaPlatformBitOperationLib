local _M = {};
local math_modf = math.modf;
local archIntBits;
if math.maxinteger then     --给我最大了那我直接算了
    archIntBits = math.modf(math.log(math.maxinteger, 2) + 1);
else                        --没有最大整数，那就测试当前双精度浮点数整数精度（同样适用于luaInteger和luaNumber两种类型）
    archIntBits = 53;
    local i = 1;
    for j = 1, 128 do     --标准C定义最大的整数位数没有超过128的
        i = i * 2;
        if i < 0 then     --负数了，说明整数溢出了，停止测试，已经得到整数上限位数-1
            archIntBits = j + 1;
            break;
        end
        if i == i + 1 then   --整数溢出了，停止测试，已经得到整数上限位数
            archIntBits = j;
            break;
        end
    end
end
_M.archIntBits = archIntBits;
local function Int2Bits(I)
    local B = {};
    local Sign = I < 0;
    if Sign then
        I = -I;
    end
    for i = 1, archIntBits do
        B[i] = I % 2;
        I = math_modf(I / 2);
    end
    if Sign then
        for i = 1, archIntBits do
            B[i] = 1 - B[i];
        end
        local Carry = 1;
        for i = 1, archIntBits do
            B[i] = B[i] + Carry;
            Carry = 0;
            if B[i] > 1 then
                B[i] = 0;
                Carry = 1;
            end
        end
    end
    return B;
end
_M.Int2Bits = Int2Bits;
local function Bits2Int(B)
    local I = 0;
    local Sign = B[archIntBits] == 1;
    if Sign then
        local Carry = 1;
        for i = 1, archIntBits do
            B[i] = 1 - B[i];
            B[i] = B[i] + Carry;
            Carry = 0;
            if B[i] > 1 then
                B[i] = 0;
                Carry = 1;
            end
        end
    end
    for i = archIntBits, 1, -1 do
        I = I * 2 + B[i];
    end
    if Sign then
        I = -I;
    end
    return (math_modf(I));     --多扩一次保证返回的是整数
end
_M.Bits2Int = Bits2Int;
local band, bor, bxor, bnot, lshift, rshift;
function band(a, b)
    local A = Int2Bits(a);
    local B = Int2Bits(b);
    local C = {};
    for i = 1, archIntBits do
        C[i] = A[i] * B[i];
    end
    return Bits2Int(C);
end

_M.band = band;
function bor(a, b)
    local A = Int2Bits(a);
    local B = Int2Bits(b);
    local C = {};
    for i = 1, archIntBits do
        C[i] = A[i] + B[i];
        if C[i] > 1 then
            C[i] = 1;
        end
    end
    return Bits2Int(C);
end

_M.bor = bor;
function bxor(a, b)
    local A = Int2Bits(a);
    local B = Int2Bits(b);
    local C = {};
    for i = 1, archIntBits do
        C[i] = A[i] + B[i];
        if C[i] > 1 then
            C[i] = 0;
        end
    end
    return Bits2Int(C);
end

_M.bxor = bxor;
function bnot(a)
    local A = Int2Bits(a);
    local C = {};
    for i = 1, archIntBits do
        C[i] = 1 - A[i];
    end
    return Bits2Int(C);
end

_M.bnot = bnot;
function lshift(a, b)
    if b == 0 then return a; end
    if b < 0 then return rshift(a, -b); end
    if b >= archIntBits then return 0; end
    local A = Int2Bits(a);
    local C = {};
    for i = 1, archIntBits do
        C[i] = A[i - b] or 0;
    end
    return Bits2Int(C);
end

_M.lshift = lshift;
function rshift(a, b)
    if b == 0 then return a; end
    if (b < 0) then return lshift(a, -b); end
    if (b >= archIntBits) then return 0; end
    local A = Int2Bits(a);
    local C = {};
    for i = 1, archIntBits do
        C[i] = A[i + b] or 0;
    end
    return Bits2Int(C);
end

_M.rshift = rshift;

return _M
