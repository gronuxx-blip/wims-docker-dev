!set slib_header_hyptiling=\
\\ -----------------------------------------------------------------------------------\
\\ Action du groupe de Moebius etendu sur le disque de Poincare\
\\ -----------------------------------------------------------------------------------\
\\ Homographie ou antihomographie selon que g[3] vaut 0 ou 1.\
mob(g,z)=if(g[3],z=conj(z));(g[1]*z+g[2])/(conj(g[2])*z+conj(g[1]));\
\\ Produit et inverse dans le groupe de Moebius etendu\
mobx(g)=[g[1],g[2];conj(g[2]),conj(g[1])];\
mob_mul(g1,g2)=my(m=mobx(g1)*mobx(if(g1[3],conj(g2),g2)));[m[1,1],m[1,2],g1[3]!=g2[3]];\
mob_inv(g)=if(g[3],[g[1],-conj(g[2]),1],[conj(g[1]),-g[2],0]);\
\\ Homographie (et anti) qui envoie 0 sur a et 1 sur b, avec a \in D et b a l'horizon\
mob_ori(a,b,c)=my(e=sqrt(b),g1=(e-conj(e)*a)/(1-norm(a)));[g1,a*conj(g1),c];\
\\ Reflexion par rapport a la geodesique qui joint a et b\
mob_ref(a,b)={\
  my(num=a*b*conj(a-b)+b-a,den=conj(a)*b-conj(b)*a,c,d,h);\
  d=if(norm(den)*1e8<norm(num),\
    if (norm(b)<norm(a),sqrt(a/conj(a)),sqrt(b/conj(b))),\
    c=num/den;(1+sqrt(1-norm(c)))/conj(c));\
  h=mob_ori(a,d);\
  mob_mul(h,mob_mul([1,0,1],mob_inv(h)))\
  };\
lft_fwd(g,beta,l)=my(e=exp(I*beta/2));mob_mul(g,[e,e*l,0]);\
\
hyp_pav(v,d,z0,eps)={\
  my(n=#v,a,b,s,s1,s2,t,t1,t2,g,gg,cd0,cd1,cdd1,cd2,r2,f1,v1,w0,z,limit,centres);\
  if(eps>=1,limit=eps;eps=0,limit=1000);\
  r2=(1-eps)^2;\
  if(!v,return(0));\
\\ Les reflexions qui engendrent W\
  g=vector(n,i,mob_ref(v[i],v[i%n+1]));\
\
\\ Creation du premier pave et de son squelette\
  \\ Pour chaque sommet, [arite restante, derniere arete cree, affixe, type, dans le disque?]\
  cd2=List(vector(n,s,[d[s]-2,if(s==1,n,s),v[s],s,norm(v[s])<r2]));\
  \\ Pour chaque arete, [origine, extremite, type, premier polygone borde, active?]\
  cd1=List(vector(n,a,[a,a%n+1,a,1,cd2[a][4]||cd2[a%n+1][4]]));\
  \\ Pour chaque arete duale [pave origine, pave extremite, arete croisee]\
  cdd1=List();\
  \\ Pour chaque pave, ses aretes et l'élément du groupe\
  cd0=List([vector(n+1,a,if(a>n,[1,0,0],a))]);\
\
  while(#cd0<limit&&f1<#cd1, f1+=1; v1=cd1[f1]; if(v1[5],\
    s=v1[3]; \\ type de l'arete (ambigu)\
\\  Nouveau pave et ses aretes, manquantes ou pas\
    w0=vector(n+1);\
    w0[n+1]=gg=mob_mul(cd0[v1[4]][n+1],g[s]);\
    w0[s]=a=f1; cd1[a][5]=0; listput(cdd1,[v1[4],#cd0+1,a]);\
    s1=cd1[a][1]; s2=cd1[a][2];\
    b=cd0[v1[4]][s%n+1];\
    if(s2!=cd1[b][1]&&s2!=cd1[b][2],t=s1;s1=s2;s2=t); \\ arete mal orientee\
    t1=(s-2)%n+1;\
    while(!cd2[s1][1]&&!w0[t1], \\ aretes precedent f1 qui sont deja la\
      w0[t1]=a=cd2[s1][2]; cd1[a][5]=0; listput(cdd1,[cd1[a][4],#cd0+1,a]);\
      s1=cd1[a][1]+cd1[a][2]-s1; t1=(t1-2)%n+1);\
    t2=s%n+1;\
    while(!cd2[s2][1]&&!w0[t2], \\ aretes suivant f1 qui sont deja la\
      w0[t2]=a=cd2[s2][2]; cd1[a][5]=0; listput(cdd1,[cd1[a][4],#cd0+1,a]);\
      s2=cd1[a][1]+cd1[a][2]-s2; t2=t2%n+1);\
    while(t1!=t2, \\ Il y a au moins deux aretes a creer\
      if(s1<s2,\
        z=mob(gg,v[t1]);\
        listput(cd2,[d[t1]-1,#cd1+1,z,t1,norm(z)<r2]);\
        listput(cd1,[s1,#cd2,t1,#cd0+1,cd2[s1][5]||cd2[#cd2][5]]); w0[t1]=#cd1;\
        cd2[s1][1]-=1; cd2[s1][2]=#cd1; s1=#cd2; t1=(t1-2)%n+1,\
        z=mob(gg,v[t2%n+1]);\
        listput(cd2,[d[t2%n+1]-1,#cd1+1,z,t2%n+1,norm(z)<r2]);\
        listput(cd1,[s2,#cd2,t2,#cd0+1,cd2[s2][5]||cd2[#cd2][5]]); w0[t2]=#cd1;\
        cd2[s2][1]-=1; cd2[s2][2]=#cd1; s2=#cd2; t2=t2%n+1));\
      listput(cd1,[s1,s2,t1,#cd0+1,cd2[s1][5]||cd2[s2][5]]); w0[t1]=#cd1;\
      cd2[s1][1]-=1; cd2[s1][2]=#cd1; cd2[s2][1]-=1; cd2[s2][2]=#cd1;\
      listput(cd0,w0)));\
  centres=vector(#cd0);\
  for(f=1,#cd0,\
    w=cd0[f]; g=w[#w]; centres[f]=mob(g,z0); w[#w]=g[3];\
    a=cd1[w[1]];b=cd1[w[n]];\
    s=a[1];if(s!=b[1]&&s!=b[2],s=a[2]);\
    for(i=1,n,a=cd1[w[i]];w[i]=s;s=a[1]+a[2]-s);\
    cd0[f]=w);\
  [vector(#cd2,i,cd2[i][3..4]),Vec(cd0),Vec(cd1),centres,Vec(cdd1)]\
};\
abc(A,B,C)={\
  if (A+B+C >= Pi, return(0));\
  my(cha=(cos(A)+cos(B)*cos(C))/(sin(B)*sin(C)),\
    chb=(cos(B)+cos(A)*cos(C))/(sin(A)*sin(C)),\
    chc=(cos(C)+cos(B)*cos(A))/(sin(B)*sin(A)));\
  [sqrt((cha-1)/(cha+1)),sqrt((chb-1)/(chb+1)),sqrt((chc-1)/(chc+1))]\
};\
tangentiel(a,auCentre)={\
  my(l,cs=apply(x->cos(x/2),a),rays=vector(1+#a),\
    k=solve(t=0,1,vecsum(apply(x->asin(t*x),cs))-Pi),\
    R=sqrt(2/(1+k)-1), g=[1,0,0], h, res=vector(#a));\
  if(auCentre,g=lft_fwd(lft_fwd([1,0,0],-asin(k*cs[1]),R),Pi/2,0));\
  for(i=1,#a,\
    rays[i]=l=abc(Pi/2,a[i]/2,asin(k*cs[i]))[3];\
    g=lft_fwd(g,0,l);\
    res[i]=mob(g,0);\
    g=lft_fwd(g,Pi-a[i],l));\
  rays[#rays]=R;\
  [res,rays]\
};\
\
catalan(d,limite,auCentre)={\
  my([h,rays]=tangentiel(apply(x->2*Pi/x,d),auCentre));\
  [hyp_pav(h,d,if(auCentre,0,rays[#rays]*I),limite),rays];\
};\
\
wims_catalan(d,limite,auCentre,option)={\
  my([pavage,rays]=catalan(d,limite,auCentre));\
  my([sommets,paves,aretes,centres,daretes]=pavage,R,z,p1,p2);\
  my(res0,res1,res2,res3,res4,n=#paves[1]-1,temp);\
  if(option==1 || option==3,\
    res1=matrix(#sommets,3,i,j,if(j==1,real(sommets[i][1]),if(j==2,imag(sommets[i][1]),sommets[i][2])));\
    res0=matrix(#paves,n+2,i,j,if(j==1,n,paves[i][j-1]));\
    res2=List(); for(i=1,#paves,listput(res2,Vec(res0[i,])));\
  );\
  if(option==2 || option==3,\
    res3=matrix(#paves,2,i,j,if(j==1,real(centres[i]),imag(centres[i])));\
    temp=vector(#paves,i,List());\
    foreach(daretes,x,listput(temp[x[1]],x[2]));\
    res4=List();\
    for(i=1,#paves,if(#temp[i],listinsert(temp[i],i,1);listput(res4,Vec(temp[i])))));\
  [res1,Vec(res2),res3,Vec(res4)];\
};\
