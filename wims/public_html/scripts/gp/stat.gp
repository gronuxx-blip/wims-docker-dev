!set slib_header_stat=\
/* preliminary GP code for stat functions */\
\
/* normal mean m std s ; assume s>0 */\
\
boxmuller() =\
{\
  my(x1,x2,w);\
  until(w && w < 1,\
    x1 = 2*random(1.) - 1;\
    x2 = 2*random(1.) - 1;\
    w = x1^2+x2^2;\
  );\
  w = sqrt(-2*log(w)/w);\
  [x1 * w, x2 * w];\
};\
\
statnormalrandom(m,s,n=0) =\
{\
  if(!n,\
    m + boxmuller()[1]*s\
  ,\\else\
    my(v = vector(n),bm);\
    for(i=1,n,\
      if(i%2,\
        bm = boxmuller();\
        v[i] = m + bm[1]*s\
      ,\\else\
        v[i] = m + bm[2]*s\
      );\
    );\
    v\
  );\
};\
\
normalpdf0(x) = exp(-sqr(x)/2)/sqrt(2*Pi);\
\
statnormalpdf(m,s,x) = normalpdf0((x-m)/s)/s;\
\
normalcdf0(x) =\
{\
  if(x<0.01,\
    erfc(-x/sqrt(2))/2\
  ,\\else\
    1 - normalcdf0(-x)\
  );\
};\
\
statnormalcdf(m,s,x) = normalcdf0((x-m)/s);\
\
normalinv0(p) =\
{\
  /* do we really need this disjonction? avoids only 1 evaluation of cdf */\
  if (p>1/2,\
    solve(z=0,oo,normalcdf0(z)-p);\
  ,\\else\
    solve(z=-oo,0,normalcdf0(z)-p);\
  );\
};\
\
statnormalinv(m,s,p) = m + s*normalinv0(p);\
\
gammarandom_weibull(c,d) =\
{\
  my(z=0, e=0, x=0);\
  while(z+e<d+x,\
    z=-log(random(1.));\
    e=-log(random(1.));\
    x=z^c;\
  );\
  x\
};\
\
gammarandom_best(d,c) =\
{\
  my(u1,u2,w,x,y);\
  while(1,\
    u1=random(1.);\
    u2=random(1.);\
    w=u1*(1-u1);\
    y=sqrt(c/w)*(u1-1/2);\
    x=d+y;\
    if(x<=0,next);\
    z=64*sqr(w)*w*sqr(u2);\
    if(z<1-2*sqr(y)/x || log(z)<2*(d*log(x/d)-y),\
      return(x)\
    );\
  );\
};\
\
\\TODO ajouter le paramètre b dans gamma\
\\comme https://gnu-octave.github.io/statistics/gamrnd.html\
statgammarandom(a,n=0)=\
{\
  if(a<1,\
    my(c=1/a, d=a^(a^(a/(1-a))*(1-a)));\
    if(!n,\
      gammarandom_weibull(c,d)\
    ,\\else\
      vector(n,i, gammarandom_weibull(c,d))\
    );\
  ,a>1,\
    my(d=a-1, c=3*a-3/4);\
    if(!n,\
      gammarandom_best(d,c);\
    ,\\else\
      vector(n,i,gammarandom_best(d,c));\
    );\
  ,\\else a==1\
    if(!n,statexprandom(1),vector(n,i,statexprandom(1)));\
  );\
};\
\
statgammapdf(a,x,g=gamma(a)) = if(x<=0, 0, x^(a-1)*exp(-x)/g);\
\
statgammacdf(a,x,g=gamma(a)) = if(x<=0, 0, 1 - incgam(a,x,g)/g);\
\
statgammainv(a,p,g=gamma(a)) = solve(x=0,oo, statgammacdf(a,x,g)-p);\
\
statchi2random(df,n=0) = 2*statgammarandom(df/2,n);\
\
statchi2pdf(df,x,g=gamma(df/2)) = statgammapdf(df/2,x/2,g)/2;\
\
statchi2cdf(df,x,g=gamma(df/2)) = statgammacdf(df/2,x/2,g);\
\
statchi2inv(df,p,g=gamma(df/2)) = 2*statgammainv(df/2,p,g);\
\
binomrandom_sumbern(nb,ps) =\
{\
  my(v=0);\
  for(i=1,nb,v+=random(1.)<ps);\
  v\
};\
\
binomrandom_inv(nb,ps) =\
{\
  statbinominv(nb,ps,random(1.))\
  \\TODO for large number of samples, could precompute cdf table + dichotomy\
  \\implement as generic discrete distribution\
};\
\
\\TODO vector n + precomputations\
statbinomrandom(nb,ps) =\
{\
  if(ps<0.1 || ps>0.9, \\TODO tune threshold\
    binomrandom_inv(nb,ps)\
  ,\\else\
    binomrandom_sumbern(nb,ps)\
  );\
};\
\
/* warning: wrt counting measure on Z, not Lebesgue measure on R */\
statbinompdf(nb,ps,x) =\
{\
  my(k=round(x));\
  if(k!=x, return(0)); \\or error?\
  binomial(nb,k)*ps^k*(1-ps)^(nb-k)\
};\
\
statbinomcdf(nb,ps,x) =\
{\
  my(k,s=0,u,a,j);\
  a = ps/(1-ps);\
  if(x<0, return(0));\
  if(x>=nb, return(1));\
  k = floor(x);\
  if(k<nb/2,\
    u = (1-ps)^nb;\
    s = u;\
    for(i=1,k,\
      u *= a*(nb-i+1)/i;\
      s += u;\
    );\
  ,\\else: k>=nb/2\
    u = ps^nb;\
    s = u;\
    for(i=k+1,nb-1,\
      u *= (nb-i+k+1)/a/(i-k);\
      s += u;\
    );\
    s = 1-s;\
  );\
  s;\
};\
\
\\TODO allow to factor out precomputations\
statbinominv(nb,ps,p) =\
{\
  my(s,u,j,a,b,v);\
  a = ps/(1-ps);\
  \\b = normalcdf0(sqrt(nb)*(1/2-ps)/sqrt(ps*(1-ps)));\
  b = 1/2;\
  if(p<b,\
    v = statbinompdf(nb,ps,0);\
    u = v;\
    j = 0;\
    while(u<p,\
      j++;\
      v *= a*(nb-j+1)/j;\
      u += v\
    );\
    j;\
  ,\\else p>=b\
    u=1;\
    j=nb;\
    v=ps^nb;\
    while(u>=p,\
      u -=v;\
      v*=1/a*j/(nb-j+1);\
      j--;\
    );\
    j+1;\
  );\
  \\*/\
};\
\
rhoz(s,c,x) = exp(-Pi*((x-c)/s)^2);\
\
zgaussrandom_reject(s,c) =\
{\
  if(s<3.8, error("This algorithm is only correct for s>=3.8"));\
  my(a = c-3.8*s,b = c+3.8*s, x);\
  while(1,\
    x = random([a,b]);\
    if(random(1.)<rhoz(s,c,x), return(x));\
  );\
};\
\
zgaussrandom_roundreject(s,c) =\
{\
  my(Z0,Z1,Z,rho0,rho1,pr1,pr2,pr3,r,x,k);\
  c = 1-c;\
  Z0 = s/2 * erfc(sqrt(Pi)*c/s);\
  Z1 = s/2 * erfc(sqrt(Pi)*(1-c)/s);\
  rho0 = rhoz(s,0,c);\
  rho1 = rhoz(s,0,c-1);\
  Z = Z0 + Z1 + rho0 + rho1;\
  pr1 = rho0/Z;\
  pr2 = (rho0+rho1)/Z;\
  pr3 = (rho0+rho1+Z0)/Z;\
  while(1,\
    r = random(1.);\
    if(r<pr1, \\proba rho0/Z\
      return(1);\
    ,r<pr2, \\proba rho1/Z\
      return(0);\
    ,r<pr3, \\proba Z0/Z\
      until(x>c, x = statnormalrandom(0,s/sqrt(2*Pi)));\
      k = ceil(x-c); \\y = k+c\
      if(random(1.) < rhoz(s,0,k+c)/rhoz(s,0,x), return(k+1))\
    ,\\else: proba Z1/Z\
      until(x<c-1, x = statnormalrandom(0,s/sqrt(2*Pi)));\
      k = floor(x-c); \\y = k+c\
      if(random(1.) < rhoz(s,0,k+c)/rhoz(s,0,x), return(k+1))\
    );\
  );\
};\
\
zgaussmass0(s,c,M) =\
{\
  sum(n=-M,0,rhoz(s,c,n)) +\
  sum(n=-M,-1,rhoz(s,c,-n));\
};\
\
zgaussmass(s,c) = \\TODO use theta()\
{\
  zgaussmass0(s,c-round(c),round(10*(1+s)))\
};\
\
\
\\s<1.\
zgaussrandom_small(s,c) =\
{\
  my(M=zgaussmass0(s,c,6),r=M*random(1.),cdf=0);\
  for(k=-6,5, \\TODO version with two halves\
    cdf += rhoz(s,c,k);\
    if(r<cdf, return(k));\
  );\
  6\
};\
\
statzgaussrandom(s,c) =\
{\
  my(k = floor(c));\
  if(k, return(statzgaussrandom(s,c-k)+k));\
  if(s<0.7, \\TODO tune threshold\
    zgaussrandom_small(s,c)\
  ,s<3.8, \\reject only valid for s>=3.8\
    zgaussrandom_roundreject(s,c)\
  ,\\else\
    zgaussrandom_reject(s,c)\
  );\
};\
\
/* warning: wrt counting measure on Z, not Lebesgue measure on R */\
statzgausspdf(s,c,x) =\
{\
  rhoz(s,c,x)/zgaussmass(s,c);\
};\
\
statzgausscdf(s,c,x) =\
{\
  my(M = round(10*(1+s)),k);\
  k = round(c);\
  c -= k;\
  x -= k;\
  x = floor(x);\
  (sum(n=-M,min(x,0),rhoz(s,c,n)) +\
  sum(n=-min(x,M),-1,rhoz(s,c,-n))\
  )\
  / zgaussmass(s,c);\
};\
\
statzgaussinv(s,c,p) =\
{\
  my(M = round(10*(1+s)),k,x,ps);\
  k = round(c);\
  c -= k;\
\
  if(p==0, return(-oo));\
  if(p==1, return(+oo));\
\
  if(p<=1/2,\
    p *= zgaussmass(s,c);\
    x = -M-1;\
    ps = 0;\
    while(ps<p,\
      x++;\
      ps += rhoz(s,c,x);\
    );\
  ,\\else p>1/2\
    p = (1-p)*zgaussmass(s,c);\
    x = M+1;\
    ps = 0;\
    while(ps<p,\
      x--;\
      ps += rhoz(s,c,x);\
    );\
  );\
\
  x+k\
};\
\
\\TODO discrete gaussian of arbitrary lattices\
\
\\mu = 1/lambda\
statexprandom(mu) = -mu*log(random(1.));\
statexppdf(mu,x) = if(x<0,0,exp(-x/mu)/mu);\
statexpcdf(mu,x) = if(x<0,0,1-exp(-x/mu));\
statexpinv(mu,p) = -log(1-p)*mu;\
\\ Lifted from Lewis Van Winkle's C implementation\
statincbeta(a,b,x)={\
  my(fr=x^a*(1-x)^b*gamma(a+b)/gamma(a)/gamma(b)/a,f=1,c=1,d=0,num,m,TINY=1e-30,cd);\
  for(i=0,200,m=i\2;\
    num=if(i==0,1,if(i%2,\
      -((a+m)*(a+b+m)*x)/((a+2*m)*(a+2*m+1)),\
      (m*(b-m)*x)/((a+2*m-1)*(a+2*m))));\
    d=1+num*d;\
    if(abs(d) < TINY, d=TINY);\
    d=1/d; c=1+num/c;\
    if(abs(c) < TINY, c=TINY);\
    cd=c*d; f*=cd;\
    if(abs(cd-1)<1e-8,return(fr*(f-1)))\
    );\
    return(1/0)\
}\
\
statbetapdf(a,b,x)=if(x<0||x>1,0,x^(a-1)*(1-x)^(b-1)*gamma(a+b)/gamma(a)/gamma(b));\
statbetacdf(a,b,x)=if(x<=0,0,if(x>=1,1,if(x>(a+1)/(a+b+2),1-statincbeta(b,a,1-x),statincbeta(a,b,x))));\
statbetainv(a,b,p)=solve(x=0,1,statbetacdf(a,b,x)-p);\
statbetarandom(a,b)=statbetainv(a,b,random(1.));\
\
statpoissrandom(lambda) =\
{\
  my(s,j,i,a);\
  a = exp(-lambda);\
  s = 1;\
  j = 0;\
  while (s>a,\
    s *= random(1.);\
    j = j+1\
  );\
  j-1\
};\
\
/* warning: wrt counting measure on Z, not Lebesgue measure on R */\
\\ lambda^k*exp(-lambda)/k! is the exp evaluation really better??\
statpoisspdf(lambda,x) = my(k=round(x)); if(k<0 || k!=x,0,exp(k*log(lambda)-lambda-lngamma(k+1)));\
\
statpoisscdf(lambda,x) =\
{\
  my(k = floor(x), g);\
  if(k<0,\
    0\
  ,k<10, \\TODO tune threshold\
    sum(j=0,k,lambda^j/j!)/exp(lambda)\
  ,k<=2*lambda, \\TODO tune threshold\
    g = k!;\
    incgam(k+1,lambda,g)/g\
  ,\\else k>2*lambda\
    1-incgamc(k+1,lambda)/k!\
  );\
};\
\
\\TODO check octave implem https://github.com/gnu-octave/statistics/tree/main/inst/dist_fun/poissinv.m\
statpoissinv(lambda,p) =\
{\
  my(x);\
  if(p==0,\
    -1\
  ,p==1,\
    oo\
  ,\\else\
    my(s=0,k=-1);\
    p *= exp(lambda);\
    while(s<p,\
      k++;\
      s += lambda^k/k!;\
    );\
    k\
  );\
};\
\
\\TODO tests beta and incbeta\
beta(a,b) = gamma(a)*gamma(b)/gamma(a+b);\
incbeta(a,b,x) = x^a/a * hypergeom([a,1-b],[a+1],x); \\https://www.fungrim.org/topic/Beta_function/\
regincbeta(a,b,x) = incbeta(a,b,x) / beta(a,b);\
\
\\ Student's t distribution, df>0 (usually a positive integer)\
\\ set student(df=oo) = normal distribution?\
studentfactor(df) = gamma((df+1)/2)/(sqrt(Pi*df)*gamma(df/2));\
\\can be simplified when df is an integer (TODO)\
\
statstudentrandom(df) =\
{\
  my(z,v);\
  z = statnormalrandom(0,1);\
  v = statchi2random(df);\
  z/sqrt(v/df)\
};\
\
statstudentpdf(df,x) = studentfactor(df) * (1+x^2/df)^(-(df+1)/2);\
\
statstudentcdf(df,x)=\
{\
  if(!x,\
    1/2\
  ,x>0,\
    1 - regincbeta(df/2,1/2,df/(x^2+df))/2\
  ,\\else x<0\
    regincbeta(df/2,1/2,df/(x^2+df))/2\
  );\
};\
\\can be simplified for small integer values of df\
\
statstudentinv(df,p) =\
{\
  if (p>1/2,\
    solve(z=0,oo,statstudentcdf(df,z)-p);\
  ,\\else\
    solve(z=-oo,0,statstudentcdf(df,z)-p);\
  );\
};\
\
\\TODO test Fisher\
\
\\x>0  if d1<2\
\\x>=0 if d1>=2\
statfisherpdf(d1,d2,x) = ((d1/d2)^(d1/2)/beta(d1/2,d2/2)) * x^(d1/2-1)*(1+x*d1/d2)^(-(d1+d2)/2);\
\
statfishercdf(d1,d2,x) = if(x==0,0,regincbeta(d1/2,d2/2,d1*x/(d1*x+d2)));\
\
statfisherinv(d1,d2,p) = solve(x=0,oo,statfishercdf(d1,d2,x)-p);\
\
statfisherrandom(d1,d2) = d2/d1 * statchi2random(d1)/statchi2random(d2);\
\
\
\\TODO test geom\
\
statgeompdf(ps,x)=\
{\
  my(k=round(x));\
  if(k!=x, return(0));\
  ps*(1-ps)^k\
};\
\
statgeomcdf(ps,x) =\
{\
  if(x<0, return(0));\
  1-(1-ps)^(floor(x)+1)\
};\
\
statgeominv(ps,p)=\
{\
  if(p<=0, return(0));\
  if(p>=1, return(oo));\
  floor(1+log(1-p)/log(1-ps))-1\
};\
\
\\TODO FIXME when ps is very small (use higher precision?)\
statgeomrandom(ps)=ceil(log(random(1.))/log(1-ps))-1;\
\
\
\\TODO test negbin\
\
statnegbinpdf(r,ps,x)=\
{\
  my(k=round(x));\
  if(k!=x, return(0));\
  binomial(k+r-1,k)*(1-ps)^k*ps^r\
};\
\
\\TODO sometimes use the formula with regincbeta?\
statnegbincdf(r,ps,x)=sum(k=0,x,statnegbinpdf(r,ps,k));\
\
\\TODO optimise?\
statnegbininv(r,ps,p)=\
{\
  my(k=-1,psum=0);\
  if(p<=0, return(0));\
  while(psum<p,\
    k++;\
    psum += statnegbinpdf(r,ps,k);\
  );\
  k\
};\
\
statnegbinrandom(r,ps)=statpoissrandom((1-ps)/ps * statgammarandom(r));\
\
erfinv(y)=my(d=1,x=sqrt(Pi)/2*abs(y)*(1+Pi*y^2/12));while(d>1.e-8,d=(abs(y)+erfc(x)-1)/(2*exp(-x^2)/sqrt(Pi));x+=d);sign(x)*x\
\
statlognormalrandom(m,s)=statlognormalinv(m,s,random(1.0));\
statlognormalinv(m,s,y)=exp(m+sqrt(2)*s*erfinv(2*y-1))\
\
/* empirical distribution (CDF only), useful for plotting with data=\
   sorted list of samples + gen_search */\
statempiricalcdf(data,x)={\
  my(i=1,j=#data,k);\
  if(x<data[1], return(0));\
  if(x>data[#data], return(1));\
  \\data[i] <= x < data[j]\
  while(j>i+1,\
    k=(i+j)\2;\
    if(data[k]<=x, i=k, j=k);\
  );\
  i/#data\
};
