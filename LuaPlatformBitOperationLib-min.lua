local a={}local b=math.modf;local c;if math.maxinteger then c=math.modf(math.log(math.maxinteger,2)+1)else c=53;local d=1;for e=1,128 do d=d*2;if d<0 then c=e+1;break end;if d==d+1 then c=e;break end end end;a.archIntBits=c;local function f(g)local h={}local i=g<0;if i then g=-g end;for d=1,c do h[d]=g%2;g=b(g/2)end;if i then for d=1,c do h[d]=1-h[d]end;local j=1;for d=1,c do h[d]=h[d]+j;j=0;if h[d]>1 then h[d]=0;j=1 end end end;return h end;a.Int2Bits=f;local function k(h)local g=0;local i=h[c]==1;if i then local j=1;for d=1,c do h[d]=1-h[d]h[d]=h[d]+j;j=0;if h[d]>1 then h[d]=0;j=1 end end end;for d=c,1,-1 do g=g*2+h[d]end;if i then g=-g end;return b(g)end;a.Bits2Int=k;local l,m,n,o,p,q;function l(r,s)local t=f(r)local h=f(s)local u={}for d=1,c do u[d]=t[d]*h[d]end;return k(u)end;a.band=l;function m(r,s)local t=f(r)local h=f(s)local u={}for d=1,c do u[d]=t[d]+h[d]if u[d]>1 then u[d]=1 end end;return k(u)end;a.bor=m;function n(r,s)local t=f(r)local h=f(s)local u={}for d=1,c do u[d]=t[d]+h[d]if u[d]>1 then u[d]=0 end end;return k(u)end;a.bxor=n;function o(r)local t=f(r)local u={}for d=1,c do u[d]=1-t[d]end;return k(u)end;a.bnot=o;function p(r,s)if s==0 then return r end;if s<0 then return q(r,-s)end;if s>=c then return 0 end;local t=f(r)local u={}for d=1,c do u[d]=t[d-s]or 0 end;return k(u)end;a.lshift=p;function q(r,s)if s==0 then return r end;if s<0 then return p(r,-s)end;if s>=c then return 0 end;local t=f(r)local u={}for d=1,c do u[d]=t[d+s]or 0 end;return k(u)end;a.rshift=q;return a