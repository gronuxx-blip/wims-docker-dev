!set slib_header_circlepack=\
eps=1e-15;\
\
/* Homographies */\
hom(z,m)=(m[1,1]*z+m[1,2])/(m[2,1]*z+m[2,2]);\
/* Image du cercle de centre z et rayon r par l'homographie m */\
homc(z,r,m)={\
  my(zz=norm(z)-norm(r),dc=m[2,2]/m[2,1], cc=(zz+z*conj(dc))/conj(z+dc));\
  cc=hom(cc,m); [cc,sqrt(norm(hom(z+r,m)-cc))]\
  };\
/* Image de la verticale d'abcisse x0 par m */\
homv(x0,m)={my(dc=m[2,2]/m[2,1], cc=2*x0+real(dc)-imag(dc)*I);\
  cc=hom(cc,m); [cc,sqrt(norm(hom(x0,m)-cc))]};\
/* Image de l'horizontale d'ordonnée y0 par m */\
homh(y0,m)={my(dc=m[2,2]/m[2,1], cc=-real(dc)+(2*y0+imag(dc))*I);\
  cc=hom(cc,m); [cc,sqrt(norm(hom(y0*I,m)-cc))]};\
/* Homographie qui envoie [u1, u2, u3] sur [v1, v2, v3] */\
homog(u,v)={my(\
  m1=[v[2]*(v[3]-v[1]),v[1]*(v[2]-v[3]);v[3]-v[1],v[2]-v[3]],\
  m2=[u[2]-u[3],u[1]*(u[3]-u[2]);u[1]-u[3],u[2]*(u[3]-u[1])]);\
  m1*m2};\
\
/* somme des demi-angles */\
sangles(r,flr,lbs)=sum(j=1,#flr,atan(lbs[flr[j]]/r));\
\
/* Point à distance r1 de z1 et r2 de z2, sens direct */\
trois(z1,r1,z2,r2)={\
  my(n=norm(z2-z1),\
    x=(1+(sqr(r1)-sqr(r2))/n)/2,\
    y=sqrt(sqr(r1)/n-sqr(x)));\
  z1+(z2-z1)*(x+y*I)\
};\
\
/* Le fichier off contient la liste ff des fleurs duales.\
   On calcule d'abord la liste ss des fleurs primales.\
   On choisit l'arête 1a et son arête duale bc privilégiées.\
   On applique l'algo pour obtenir les rayons des autres disques.\
   On place les points sur les bords du rectangle.\
   On cherche le sommet (ou la face) de plus grand degré\
   ainsi que le sommet ou la face opposé. Ils sont envoyés sur\
   le cercle unité et un cercle concentrique plus petit.\
   On renvoie les quatre listes (centres et rayons pour sommets et faces) */\
\
polycircle(ff)={\
  my(ns=1,nf=#ff,dgs,m,f,ss,i,j,k,l,lbs,lbf,a,b,c,d,u,pts,ptf,cs,cf,\
    f1,fb,fc,fl,sa,ssa,w,h,scale,again,s0,f0,flip,aa,bb,cc,djs,djf,p,ma);\
\
/* Dans la version pari, les sommets sont numérotés de 1 à ns */\
  for (i=1, nf, for (j = 1, #ff[i], if((ff[i][j]+=1)>ns,ns=ff[i][j])));\
\
/* calcul des fleurs primales */\
  dgs=vector(ns); /* degrés des sommets*/\
  m=matrix(ns,ns);\
/* m[aa,bb]==i!=0 ssi (aa,bb) fait partie du bord orienté de la face i */\
  for(i=1, nf, f=ff[i]; for(j = 1, #f, dgs[f[j]]+=1; m[f[j],f[1+j%#f]]=i));\
\
  ma=m;\
  ss=vector(ns);\
  for(i=1, ns,\
    fl=vector(dgs[i]);\
    j=1;while(!m[i,j],j++); /* chercher une pétale */\
    for (l=1, dgs[i],\
      fl[l]=k=m[i,j];\
      j=1;while(m[j,i]!=k,j++)); /* chercher la pétale suivante */\
    ss[i]=fl;\
  );\
\
/* Calcul des rayons */\
  lbs=vector(ns,x,1);\
  lbf=vector(nf,x,1);\
\
  s1=ss[1]; b = s1[1]; c = s1[2];\
  fb=ff[b]; fc=ff[c];\
  for (j = 1, #fc, if (fc[j] == 1, a = fc[1+j%#fc]; break));\
  sa=ss[a];\
  lbs[1]=lbs[a]=lbf[b]=lbf[c]=eps^-2;\
\
  again = 1;\
  while (again, again=0;\
    for (i=2, ns, if (i != a,\
      ssa=sangles(lbs[i],ss[i],lbf);\
      if (abs(ssa-Pi)> eps,\
        lbs[i]*=tan(ssa/#ss[i])/tan(Pi/#ss[i]); again=1)));\
    for (i=1, nf, if (i != b && i != c,\
          ssa=sangles(lbf[i],ff[i],lbs);\
      if (abs(ssa-Pi)> eps,\
        lbf[i]*=tan(ssa/#ff[i])/tan(Pi/#ff[i]); again=1)))\
    );\
\
/* Calcul des positions */\
\
  pts=vector(ns);\
  ptf=vector(nf);\
  cs=vector(ns);\
  cf=vector(nf);\
\
 /* Tour du rectangle fondamental, sens horaire! */\
\
  w = 0; h = 0; k = 0; /* nombre de points calculés */\
\
  for (i = 3, #s1,\
    d = s1[i]; h += lbf[d]; ptf[d] = w+h*I; cf[d] = 1; k++; h += lbf[d]);\
  i = 1; while (fb[i] != 1, i = 1+i%#fb);\
  while ((d = fb[i = 1+i%#fb]) != a,\
    w += lbs[d]; pts[d] = w+h*I; cs[d] = 1; k++; w += lbs[d]);\
\
  /* Mise à l'échelle et stockage du rectangle */\
\
  scale = min (4 / w, 6 / h);\
  for (i = 1, ns, lbs[i] *= scale; pts[i] *= scale);\
  for (i = 1, nf, lbf[i] *= scale; ptf[i] *= scale);\
  w *= scale; h *= scale;\
\
  lbs[1] = lbf[b] = lbs[a] = lbf[c] = 0;\
  pts[1] = 0; pts[a] = w; ptf[b] = h; ptf[c] = 0;\
  k += 4; /* On connait 1, a, b et c, mais on ne le dit pas dans cs et cf */\
\
  i = 1; while (sa[i] != b, i = 1+i%#sa);\
  while ((d = sa[i = 1+i%#sa]) != c,\
    h -= lbf[d]; ptf[d] = w+h*I; cf[d] = 1; k++; h -= lbf[d]);\
  i = 1; while (fc[i] != a, i = 1+i%#fc);\
  while ((d = fc[i = 1+i%#fc]) != 1,\
    w -= lbs[d]; pts[d] = w+h*I; cs[d] = 1; k++; w -= lbs[d]);\
\
/* Ici, on a fait le tour du rectangle, donc h==w==0 (I hope) */\
\
  while(k<ns+nf,\
    for(aa=2,ns,if(aa!=a && cs[aa], fl = ss[aa]; for (i=1,#fl, if(cf[fl[i]],\
      bb = fl[i]; cc = fl[1+i%#fl];\
      if(!cf[cc] && cc != b && cc != c,\
      ptf[cc] = trois(pts[aa], sqrt(lbs[aa]^2+lbf[cc]^2),\
        ptf[bb], lbf[bb]+lbf[cc]);\
      cf[cc] = 1; k++)))));\
    for(aa=1,nf,if(aa!=b && aa!= c && cf[aa], fl = ff[aa]; for (i=1,#fl, if(cs[fl[i]],\
      bb = fl[i]; cc = fl[1+i%#fl];\
      if(!cs[cc] && cc != 1 && cc != a,\
      pts[cc] = trois(ptf[aa], sqrt(lbf[aa]^2+lbs[cc]^2),\
        pts[bb], lbs[bb]+lbs[cc]);\
      cs[cc]=1; k++))))));\
\
/* return([pts,lbs,ptf,lbf] pour le diagramme avec un rectangle */\
\
/* Détermination du point (s0 ou f0) de degré maximal */\
  f0=1; for(i=2,nf,if(#ff[i]>#ff[f0],f0=i));\
  s0=1; for(i=2,ns,if(#ss[i]>#ss[s0],s0=i));\
  flip = #ss[s0] > #ff[f0];\
/* Détermination du point (s1 ou f1) le plus éloigné de s0 ou f0 */\
  djs = vector(ns,i,-1); djf = vector(nf,i,-1);\
  d = 0; k=1; if (flip,djs[s0]=0,djf[f0]=0);\
  while(k<ns+nf, if((d+flip)%2,\
    for(s = 1, ns, if(djs[s] == d,\
      for(j = 1, #ss[s], if(djf[ss[s][j]] < 0,\
        k += 1; f1 = ss[s][j]; djf[f1] = d+1\
	)))),\
    for(f = 1, nf, if(djf[f] == d,\
      for(j = 1, #ff[f], if(djs[ff[f][j]] < 0,\
        k += 1; s1 = ff[f][j]; djs[s1] = d+1\
	)))));\
    d += 1);\
\
/* et parmi ceux-là, celui qui a le plus grand degré ? */\
  if((d+flip)%2,\
    for(s = 1, ns, if(djs[s] == d && #ss[s] > #ss[s1], s1=s)),\
    for(f = 1, nf, if(djf[f] == d && #ff[f] > #ff[f1], f1=f)));\
\
  d=(d+flip)%2;\
\
/* Il faut maintenant trouver l'homographie qui envoie le disque de sf0\
   sur le disque unité et celui de sf1 sur un disque centré en 0\
   de rayon plus petit */\
\
if(flip,\
  cc=pts[s0]; rr=lbs[s0];\
  m=homog(if (s0 == 1 || s0 == a,\
            [cc-1.23*I,cc,cc+3.78*I],\
            [cc-rr*exp(I), cc+rr, cc+rr*exp(1.52*I)]),[-I,1,I]),\
  cc=ptf[f0]; rr=lbf[f0];\
  m=homog(if (f0 == b || f0 == c,\
            [cc*I-1.23456789,cc*I,cc*I+3.78243577],\
	    [cc-rr*exp(I), cc+rr, cc+rr*exp(1.52*I)]),[-I,1,I]));\
\
  u=if(d%2,if(s1==1||s1==a, homv(pts[s1],m), homc(pts[s1],lbs[s1],m)),\
           if(f1==b||f1==c, homh(ptf[f1],m), homc(ptf[f1],lbf[f1],m)));\
\
  if(sqrt(norm(u[1]))+u[2]>1, m=[0,1;1,0]*m; u=homc(u[1],u[2],[0,1;1,0]));\
\
  r0=sqrt(norm(u[1])); t1=r0-u[2];\
  a1=log((1+t1)/(1-t1));\
  t2=r0+u[2]; a2=log((1+t2)/(1-t2)); aa=exp((a1+a2)/2);\
  t = (aa-1)/(aa+1); u[1]*=t/r0; /* u[1] est maintenant le centre hyper*/\
\
  m=[1,-u[1];-conj(u[1]),1]*m;\
  for (i=1,ns,u=if(i==1||i==a, homv(pts[i],m),homc(pts[i],lbs[i],m));\
    pts[i]=if(norm(u[1])<eps,0,u[1]);lbs[i]=u[2]);\
  for (i=1,nf,u=if(i==b||i==c, homh(ptf[i],m),homc(ptf[i],lbf[i],m));\
    ptf[i]=if(norm(u[1])<eps,0,u[1]);u[1];lbf[i]=u[2]);\
\
/* Une rotation pour faire plus joli */\
  p=if(flip,ptf[ss[s0][1]],pts[ff[f0][1]]);p/=sqrt(norm(p));\
  for (i=1,ns,pts[i]/=p);\
  for (i=1,nf,ptf[i]/=p);\
\
/* [pts,lbs,ptf,lbf] */\
 [matrix(#lbs,3,i,j,if(j==1,real(pts[i]),if(j==2,imag(pts[i]),lbs[i]))),\
  matrix(#lbf,3,i,j,if(j==1,real(ptf[i]),if(j==2,imag(ptf[i]),lbf[i]))),ma]\
};\
