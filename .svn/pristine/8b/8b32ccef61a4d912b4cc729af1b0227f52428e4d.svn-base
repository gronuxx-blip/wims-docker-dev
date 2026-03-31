!set slib_header_hyppolygon=\
\\ -----------------------------------------------------------------------------------\
\\ Action du groupe de Moebius etendu sur le disque de Poincare\
\\ -----------------------------------------------------------------------------------\
\\ Homographie ou antihomographie selon que g[3] vaut 0 ou 1.\
mob(g,z)=if(g[3],z=conj(z));(g[1]*z+g[2])/(conj(g[2])*z+conj(g[1]));\
\\ Produit et inverse dans le groupe de Moebius etendu\
mobx(g)=[g[1],g[2];conj(g[2]),conj(g[1])];\
mob_mul(g1,g2)=my(m=mobx(g1)*mobx(if(g1[3],conj(g2),g2)));[m[1,1],m[1,2],g1[3]!=g2[3]];\
\\ Homographie (et anti) qui envoient (0,1) sur (a,b), ou a est un point du disque et b a l'horizon\
\\ Homographie (et anti) qui envoient (a,b) sur (c,d), sous l'hypothèse d(a,b)=d(c,d)\
\
\\ -----------------------------------------------------------------------------------\
\\ Creation de polygones convexes d'angles donnes\
\\ -----------------------------------------------------------------------------------\
\\ S'il existe un triangle de côtés a,b,c et angles A,B,C, les fonctions suivantes\
\\ renvoient les paramètres manquants. Sinon, elles renvoient 0\
abc(A,B,C)={\
  if (A+B+C >= Pi, return(0));\
  my(cha=(cos(A)+cos(B)*cos(C))/(sin(B)*sin(C)),\
    chb=(cos(B)+cos(A)*cos(C))/(sin(A)*sin(C)),\
    chc=(cos(C)+cos(B)*cos(A))/(sin(B)*sin(A)));\
  [sqrt((cha-1)/(cha+1)),sqrt((chb-1)/(chb+1)),sqrt((chc-1)/(chc+1))]\
};\
\\ La tortue hyperbolique, turn left beta, then forward l\
lft_fwd(g,beta,l)=my(e=exp(I*beta/2));mob_mul(g,[e,e*l,0]);\
\\ Entree: n angles entre 0 et Pi, dont la somme est inferieure a (n-2)*Pi\
\\ Sortie: L'unique polygone convexe dont tous les cotes sont tangents a un meme cercle\
\\   de centre 0,  d'angles interieurs a_i et dont le premier sommet est un reel positif.\
\
tangentiel(a,auCentre)={\
  my(l,cs=apply(x->cos(x/2),a),\
    k=solve(t=0,1,vecsum(apply(x->asin(t*x),cs))-Pi),\
    R=sqrt(2/(1+k)-1), g=[1,0,0], h, res=vector(#a));\
  if(auCentre,g=lft_fwd(lft_fwd([1,0,0],-asin(k*cs[1]),R),Pi/2,0));\
  for(i=1,#a,\
    l=abc(Pi/2,a[i]/2,asin(k*cs[i]))[3];\
    g=lft_fwd(g,0,l);\
    res[i]=mob(g,0);\
    g=lft_fwd(g,Pi-a[i],l));\
  res\
}
