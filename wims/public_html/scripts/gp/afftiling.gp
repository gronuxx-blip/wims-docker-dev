!set slib_header_afftiling=\
\\ -----------------------------------------------------------------------------------\
\\ Action du groupe des isometries sur le plan (affine)\
\\ -----------------------------------------------------------------------------------\
\\ Isometrie directe ou indirecte selon que g[3] vaut 0 ou 1.\
iso(g,z)=if(g[3],z=conj(z));g[1]*z+g[2];\
\\ Produit et inverse dans le groupe des isometries\
iso_mul(g1,g2)=if(g1[3],g2=conj(g2));[g1[1]*g2[1],g1[1]*g2[2]+g1[2],g1[3]!=g2[3]];\
iso_inv(g)=if(g[3],[1/conj(g[1]),-conj(g[2]/g[1]),1],[1/g[1],-g[2]/g[1],0]);\
\\ Reflexion par rapport à la droite qui passe par a et b\
iso_ref(a,b)={\
  my(c=(a-b)/conj(a-b));\
  [c,a-c*conj(a),1]\
  };\
\
\\ ------------------------------------------------------------------------------------\
\\ La tortue classique:\
\\ ------------------------------------------------------------------------------------\
\\ turn left beta, then forward l. Renvoie la nouvelle attitude de la tortue\
lft_fwd(g,beta,l)=my(e=exp(I*beta));iso_mul(g,[e,e*l,0]);\
\
\\ ------------------------------------------------------------------------------\
\\ Pavage obtenu a partir d'un polygone convexe pavant\
\\ ------------------------------------------------------------------------------\
\\ Entree:  v_i, n points du plan et d_i>2 des entiers\
\\   On suppose que les v_i forment le bord oriente d'un polygone convexe (pave) P0\
\\   dont l'angle intérieur au point v_i est  2Pi/d_i\
\\   Si d_i est impair, les deux cotes qui touchent v_i consecutifs sont supposes egaux\
\\   z0 est cense etre un point quelconque du polygone\
\\   Renvoie les paves dont au moins un sommet est dans le disque euclidien D(0,1-eps)\
\\   mais on en prend au maximum limit.\
\\ Sortie: [sommets, paves, aretes, centres, aretes_duales]\
\\   Un sommet est un couple [affixe, type]\
\\   Un pave est un tableau de n entiers (numeros de sommets) et une isometrie\
\\   Une arete est un vecteur a 5 composantes\
\\   [origine, extremite, type, numero du premier pave que l'arete borde, sur le bord ?]\
\\   Les centres sont les images de z0 dans chaque pave.\
\\   Une arete duale est un vecteur a 3 composantes\
\\   [pave_origine, pave_extremite, arete croisee]\
\
aff_pav(v,d,z0,eps,limit)={\
  my(n=#v,a,b,s,s1,s2,t,t1,t2,g,gg,cd0,cd1,cdd1,cd2,r2,f1,v1,w0,z,centres);\
  r2=(1-eps)^2;\
  if(!v,return(0));\
\
\\ Les reflexions qui engendrent W\
  g=vector(n,i,iso_ref(v[i],v[i%n+1]));\
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
    w0[n+1]=gg=iso_mul(cd0[v1[4]][n+1],g[s]);\
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
        z=iso(gg,v[t1]);\
        listput(cd2,[d[t1]-1,#cd1+1,z,t1,norm(z)<r2]);\
        listput(cd1,[s1,#cd2,t1,#cd0+1,cd2[s1][5]||cd2[#cd2][5]]); w0[t1]=#cd1;\
        cd2[s1][1]-=1; cd2[s1][2]=#cd1; s1=#cd2; t1=(t1-2)%n+1,\
        z=iso(gg,v[t2%n+1]);\
        listput(cd2,[d[t2%n+1]-1,#cd1+1,z,t2%n+1,norm(z)<r2]);\
        listput(cd1,[s2,#cd2,t2,#cd0+1,cd2[s2][5]||cd2[#cd2][5]]); w0[t2]=#cd1;\
        cd2[s2][1]-=1; cd2[s2][2]=#cd1; s2=#cd2; t2=t2%n+1));\
      listput(cd1,[s1,s2,t1,#cd0+1,cd2[s1][5]||cd2[s2][5]]); w0[t1]=#cd1;\
      cd2[s1][1]-=1; cd2[s1][2]=#cd1; cd2[s2][1]-=1; cd2[s2][2]=#cd1;\
      listput(cd0,w0)));\
  centres=vector(#cd0);\
  for(f=1,#cd0,\
    w=cd0[f]; g=w[#w]; centres[f]=iso(g,z0); w[#w]=g[3];\
    a=cd1[w[1]];b=cd1[w[n]];\
    s=a[1];if(s!=b[1]&&s!=b[2],s=a[2]);\
    for(i=1,n,a=cd1[w[i]];w[i]=s;s=a[1]+a[2]-s);\
    cd0[f]=w);\
  [vector(#cd2,i,cd2[i][3..4]),Vec(cd0),Vec(cd1),centres,Vec(cdd1)]\
};\
\
\\ -----------------------------------------------------------------------------------\
\\ Polygones tangentiels\
\\ -----------------------------------------------------------------------------------\
\\ Entree: n angles entre 0 et Pi, dont la somme vaut (n-2)*Pi\
\\ Sortie: [res,rays] ou\
\\   res est un polygone convexe d'angles interieurs a_i\
\\   dont tous les cotes sont tangents a un cercle de rayon 1,\
\\   - Si le parametre booleen auCentre est 0, le cote [res[n],res[1]] est porte par l'axe reel\
\\     et le cercle lui est tangent au point 0. En consequence son centre est I\
\\   - Sinon le cercle est le cercle unite et res[1] est reel positif\
\\   rays[i] contient la distance de res[i] aux deux points de tangence qui l'encadrent\
\
tangentiel(a,auCentre)={\
  my(l,rays=vector(1+#a), g=[1,0,0], res=vector(#a));\
  if(auCentre,g=lft_fwd(lft_fwd([1,0,0],(Pi-a[1])/2,1),Pi/2,0));\
  for(i=1,#a,\
    rays[i]=l=1/tan(a[i]/2);\
    g=lft_fwd(g,0,l);\
    res[i]=iso(g,0);\
    g=lft_fwd(g,Pi-a[i],l));\
  rays[#rays]=1;\
  [res,rays]\
};\
\
\\ On se donne n entiers d[i] >= 3, avec la convention d[] périodique modulo n\
\\ On suppose que si d[i] est impair, alors on a d[i-1]=d[i+1].\
\\ Calcule le pavage associé au polygone tangentiel d'angles interieurs 2*Pi/d[i]\
\
catalan(d,limit,auCentre)={\
  my(eps,[h,rays]=tangentiel(apply(x->2*Pi/x,d),auCentre));\
  if(limit<1,eps=limit;limit=100,eps=1/sqrt(limit));\
  h*=eps; rays*=eps;\
  [aff_pav(h,d,if(auCentre,0,eps*I),eps,limit),rays];\
};\
\
wims_catalan(d,limit,auCentre,option)={\
  my([pavage,rays]=catalan(d,limit,auCentre));\
  my([sommets,paves,aretes,centres,daretes]=pavage,z,p1,p2);\
  my(res0,res1,res2,res3,res4,n=#paves[1]-1,temp);\
  if(option==1 || option==3 ,\
    res1=matrix(#sommets,2,i,j,if(j==1,real(sommets[i][1]),imag(sommets[i][1])));\
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
